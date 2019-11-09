//
//  PhotosCollectionViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/7/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

protocol PhotosCollectionViewModelDelegate: class {
	func photosCollection(didSelect photo: Photo)
}

class PhotosCollectionViewModel: WaterfallCollectionViewModel {
	
	enum Section: Int, CaseIterable {
		case photos
		case loading
	}
	
	var photoCellViewModels = [PhotoCellViewModel]()
	
	let cellViewModelTypes: [ItemRepresentable.Type] = [
		PhotoCellViewModel.self,
		LoadingCellViewModel.self
	]
	
	let imageStore: ImageStore
	let paginatedPhotosController: PaginatedPhotosController
	
	var isLoading: Bool {
		if case .loading(_) = paginatedPhotosController.status {
			return true
		} else {
			return false
		}
	}
	
	var insertItems: (([IndexPath]) -> Void)?
	var reloadData: (() -> Void)?
	var reloadSections: ((IndexSet) -> Void)?
	var performBatchUpdates: ((() -> Void) -> Void)?
	
	var numberOfSections: Int {
		return Section.allCases.count
	}
	
	weak var delegate: PhotosCollectionViewModelDelegate?
	
	init(
		paginatedPhotosController: PaginatedPhotosController,
		imageStore: ImageStore)
	{
		self.imageStore = imageStore
		self.paginatedPhotosController = paginatedPhotosController
		paginatedPhotosController.delegate = self
		fetchAdditionalPhotos()
	}
	
	func columnCount(forSection section: Int) -> Int {
		guard let sectionType = Section.init(rawValue: section) else {
			return 0
		}
		
		switch sectionType {
		case .photos:
			let bounds = UIScreen.main.bounds
			let isPortrait = bounds.height > bounds.width
			return isPortrait ? 2 : 3
		case .loading:
			return 1
		}
	}
	
	func registerCells(collectionView: UICollectionView) {
		for cellViewModelType in cellViewModelTypes {
			cellViewModelType.registerCell(collectionView: collectionView)
		}
	}
	
	func numberOfItems(inSection section: Int) -> Int {
		guard let sectionType = Section.init(rawValue: section) else {
			return 0
		}
		
		switch sectionType {
		case .photos:
			return photoCellViewModels.count
		case .loading:
			return isLoading ? 1 : 0
		}
	}
	
	func viewModelForItem(at indexPath: IndexPath) -> ItemRepresentable {
		let row = indexPath.row
		let section = indexPath.section
		
		guard let sectionType = Section.init(rawValue: section) else {
			fatalError("Invalid section")
		}
		
		switch sectionType {
		case .photos:
			return photoCellViewModels[row]
		case .loading:
			return LoadingCellViewModel()
		}
	}
	
	func sizeForItem(at indexPath: IndexPath) -> CGSize {
		let row = indexPath.row
		let section = indexPath.section
		
		guard let sectionType = Section.init(rawValue: section) else {
			fatalError("Invalid section")
		}
		
		switch sectionType {
		case .photos:
			return photoCellViewModels[row].photo.size ?? CGSize(width: 300, height: 300)
		case .loading:
			return CGSize(width: 0, height: 100)
		}
	}
	
	func didSelectItem(at indexPath: IndexPath) {
		let row = indexPath.row
		let section = indexPath.section
		
		guard let sectionType = Section.init(rawValue: section) else {
			fatalError("Invalid section")
		}
		
		switch sectionType {
		case .photos:
			let photo = photoCellViewModels[row].photo
			delegate?.photosCollection(didSelect: photo)
		case .loading:
			break
		}
	}
	
	func prefetchItems(at indexPaths: [IndexPath]) {
		indexPaths.forEach { indexPath in
			let row = indexPath.row
			let imageUrl = photoCellViewModels[row].photo.imageUrl
			imageStore.fetchImage(withUrl: imageUrl)
		}
	}
	
	func cancelPrefetchingForItems(at indexPaths: [IndexPath]) {
		
		indexPaths.forEach { indexPath in
			let row = indexPath.row
			let imageUrl = photoCellViewModels[row].photo.imageUrl
			imageStore.cancelFetch(forImageWithUrl: imageUrl)
		}
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height
		let scrollViewHeight = scrollView.frame.height
		
		if
			offsetY > contentHeight - scrollViewHeight - 800,
			case .upToDate(_) = paginatedPhotosController.status
		{
			fetchAdditionalPhotos()
		}
	}
}

extension PhotosCollectionViewModel {
	
	func fetchAdditionalPhotos() {
		paginatedPhotosController.fetchNextPage()
	}
}

extension PhotosCollectionViewModel: PaginatedPhotosControllerDelegate {
	
	func photosController(statusDidChangeTo status: PaginatedPhotosController.Status) {
		switch status {
		case .upToDate(let photos, let nextPage):
			guard nextPage > 1 else {
				photoCellViewModels.removeAll()
				let indexSet = IndexSet(integer: Section.loading.rawValue)
				reloadSections?(indexSet)
				break
			}
			insert(photos: photos)
		case .finished(let photos):
			insert(photos: photos)
		default:
			let indexSet = IndexSet(integer: Section.loading.rawValue)
			reloadSections?(indexSet)
		}
	}
	
	func insert(photos: [Photo]) {
		let oldViewModelCount = photoCellViewModels.count
		let newViewModelCount = oldViewModelCount + photos.count
		
		let indexPaths = (oldViewModelCount..<newViewModelCount).map {
			IndexPath(row: $0, section: 0)
		}
		
		let newCellViewModels = photos.map {
			PhotoCellViewModel(photo: $0, imageStore: imageStore)
		}
		
		photoCellViewModels.append(contentsOf: newCellViewModels)
		performBatchUpdates?({ [weak self] in
			self?.insertItems?(indexPaths)
			self?.reloadSections?(IndexSet(integer: Section.loading.rawValue))
		})
	}
}
