//
//  PhotoItemViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/7/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

/// Cell view model that controls asynchonous loading of an image cell
class PhotoCellViewModel {

	// Photo to be visualized
	let photo: Photo
	
	//Networking
	let imageStore: ImageStore
	
	init(photo: Photo, imageStore: ImageStore) {
		self.photo = photo
		self.imageStore = imageStore
	}
}

extension PhotoCellViewModel: ItemRepresentable {
	static func registerCell(collectionView: UICollectionView) {
		collectionView.register(
			ImageCell.self,
			forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
	}
	
	func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: ImageCell.reuseIdentifier,
			for: indexPath)
		
		if let imageCell = cell as? ImageCell {
			
			// Set the cell's representedId to the view model's object identifier
			imageCell.representedId = ObjectIdentifier(self)
			
			let imageUrl = photo.imageUrl
			
			//First attempt to get a cached image if available
			if let cachedImage = imageStore.fetchedImage(withUrl: imageUrl) {
				imageCell.setImage(to: cachedImage)
			} else {
				// If image needs to be fetched, set the iamge cell's image to nil so the imageView's background can act as a placeholder
				imageCell.setImage(to: nil)
				
				// Fetch the image
				imageStore.fetchImage(withUrl: imageUrl) { result in
					switch result {
					case .failure(_):
						break
					case .success(let image):
						// If the cell is still represented by this view model and if the image url hasn't changed, set the image cell's image
						if imageCell.representedId == ObjectIdentifier(self) {
							imageCell.setImage(to: image, animated: true)
						}
					}
				}
			}
		}
		return cell
	}
}
