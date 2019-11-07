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
		
	}
	
	func cancelPrefetchingForItems(at indexPaths: [IndexPath]) {
		
	}
}
