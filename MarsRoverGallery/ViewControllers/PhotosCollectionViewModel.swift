//
//  PhotosCollectionViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/7/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class PhotosCollectionViewModel: WaterfallCollectionViewModel {
	
	var photoCellViewModels = [PhotoCellViewModel]()
	
	let cellViewModelTypes: [ItemRepresentable.Type] = [
		PhotoCellViewModel.self
	]
	
	let imageStore: ImageStore
	let paginatedPhotosController: PaginatedPhotosController
	
	var insertItems: (([IndexPath]) -> Void)?
	var reloadData: (() -> Void)?
	
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
		return 2
	}
	
	func registerCells(collectionView: UICollectionView) {
		for cellViewModelType in cellViewModelTypes {
			cellViewModelType.registerCell(collectionView: collectionView)
		}
	}
	
	func numberOfItems(inSection section: Int) -> Int {
		switch section {
		case 0:
			return photoCellViewModels.count
		default:
			return 0
		}
	}
	
	func viewModelForItem(at indexPath: IndexPath) -> ItemRepresentable {
		let row = indexPath.row
		return photoCellViewModels[row]
	}
	
	func sizeForItem(at indexPath: IndexPath) -> CGSize {
		let row = indexPath.row
		let size = photoCellViewModels[row].photo.size ?? CGSize(width: 300, height: 300)
		return size
	}
	
	func didSelectItem(at indexPath: IndexPath) {
		
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
			if nextPage == 1 {
				photoCellViewModels.removeAll()
			} else {
				insert(photos: photos)
			}
		default:
			break
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
		insertItems?(indexPaths)
	}
}
