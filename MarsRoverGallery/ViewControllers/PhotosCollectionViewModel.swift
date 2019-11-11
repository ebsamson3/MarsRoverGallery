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

/// View model for a mars rover photo gallery
class PhotosCollectionViewModel: WaterfallCollectionViewModel {
	
	/// Photo gallery section types
	enum Section: Int, CaseIterable {
		case photos
		case loading
	}
	
	///MARK: Cell View Models
	var photoCellViewModels = [PhotoCellViewModel]()
	
	let cellViewModelTypes: [ItemRepresentable.Type] = [
		PhotoCellViewModel.self,
		LoadingCellViewModel.self
	]
	

	
	var isLoading: Bool {
		if case .loading(_) = paginatedPhotosController.status {
			return true
		} else {
			return false
		}
	}
	
	//MARK: CollectionViewModel protocol parameters
	
	var insertItems: (([IndexPath]) -> Void)?
	var reloadData: (() -> Void)?
	var reloadSections: ((IndexSet) -> Void)?
	var performBatchUpdates: ((() -> Void) -> Void)?
	
	var numberOfSections: Int {
		return Section.allCases.count
	}
	
	//MARK: Parameters
	
	weak var delegate: PhotosCollectionViewModelDelegate?
	let imageStore: ImageStore
	let paginatedPhotosController: PaginatedPhotosController
	
	
	
	init(
		paginatedPhotosController: PaginatedPhotosController,
		imageStore: ImageStore)
	{
		self.imageStore = imageStore
		self.paginatedPhotosController = paginatedPhotosController
		paginatedPhotosController.delegate = self
		fetchAdditionalPhotos()
	}
	
	func registerCells(collectionView: UICollectionView) {
		for cellViewModelType in cellViewModelTypes {
			cellViewModelType.registerCell(collectionView: collectionView)
		}
	}
	
	//MARK: UICollectionViewDataSource
	
	func numberOfItems(inSection section: Int) -> Int {
		guard let sectionType = Section.init(rawValue: section) else {
			return 0
		}
		
		switch sectionType {
		case .photos:
			return photoCellViewModels.count
		case .loading:
			return isLoading ? 1 : 0 // If loading add a loading section to the collection view
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
	
	//MARK: Waterfall Layout
	func columnCount(forSection section: Int) -> Int {
		guard let sectionType = Section.init(rawValue: section) else {
			return 0
		}
		
		// Change the number of columns based on device orientation
		switch sectionType {
		case .photos:
			let bounds = UIScreen.main.bounds
			let isPortrait = bounds.height > bounds.width
			return isPortrait ? 2 : 3
		case .loading:
			return 1
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
			return CGSize(width: 0, height: 100) // Setting width to 0 allows you to set the true height
		}
	}
	
	//MARK: CollectionViewDelegate
	func didSelectItem(at indexPath: IndexPath) {
		let row = indexPath.row
		let section = indexPath.section
		
		guard let sectionType = Section.init(rawValue: section) else {
			fatalError("Invalid section")
		}
		
		switch sectionType {
		case .photos:
			let photo = photoCellViewModels[row].photo
			
			// Tell the delegate that a photo was selected
			delegate?.photosCollection(didSelect: photo)
		case .loading:
			break
		}
	}
	
	//MARK: Prefetching
	func prefetchItems(at indexPaths: [IndexPath]) {
		indexPaths.forEach { indexPath in
			let row = indexPath.row
			
			// Prefetch photos for specific index paths using the image store
			if photoCellViewModels.count > row {
				let imageUrl = photoCellViewModels[row].photo.imageUrl
				imageStore.fetchImage(withUrl: imageUrl)
			}
		}
	}
	
	func cancelPrefetchingForItems(at indexPaths: [IndexPath]) {
		
		// Cancel any image store fetches that are no longer neccesary
		indexPaths.forEach { indexPath in
			let row = indexPath.row
			if photoCellViewModels.count > row {
				let imageUrl = photoCellViewModels[row].photo.imageUrl
				imageStore.cancelFetch(forImageWithUrl: imageUrl)
			}
		}
	}
	
	//MARK: ScrollViewDelegate
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height
		let scrollViewHeight = scrollView.frame.height
		
		// When the scroll view offset is past a certain value fetch the next page of results (if up to date)
		if
			offsetY > contentHeight - scrollViewHeight - 800,
			case .upToDate(_) = paginatedPhotosController.status
		{
			fetchAdditionalPhotos()
		}
	}
}

extension PhotosCollectionViewModel {
	
	/// Fetch next page of photos
	func fetchAdditionalPhotos() {
		paginatedPhotosController.fetchNextPage()
	}
}

//MARK: Photo fetching
extension PhotosCollectionViewModel: PaginatedPhotosControllerDelegate {
	
	// Delegate method that notifies the collection view model when the paginated photos controller status changes
	func photosController(statusDidChangeTo status: PaginatedPhotosController.Status) {
		switch status {
		case .upToDate(let photos, let nextPage):
			guard nextPage > 1 else {
				// If request is at page 0, clear all existing photos
				photoCellViewModels.removeAll()
				imageStore.removeAllObjects()
				reloadData?()
				return
			}
			// Otherwise insert photos
			insert(photos: photos)
		case .finished(let photos):
			insert(photos: photos)
		default:
			// Any other status change updates the loading state of the collection view
			let indexSet = IndexSet(integer: Section.loading.rawValue)
			reloadSections?(indexSet)
		}
	}
	
	/// Insert photos into the collection view
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
