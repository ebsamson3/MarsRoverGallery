//
//  PhotoItemViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/7/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class PhotoCellViewModel {
	
	let photo: Photo
	
	init(photo: Photo) {
		self.photo = photo
	}
}

extension PhotoCellViewModel: ItemRepresentable {
	static func registerCell(collectionView: UICollectionView) {
		collectionView.register(
			PhotoCell.self,
			forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
	}
	
	func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: PhotoCell.reuseIdentifier,
			for: indexPath)
		
		if let photoCell = cell as? PhotoCell {
			
		}
		
		return cell
	}
}
