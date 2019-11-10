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
			imageCell.representedId = ObjectIdentifier(self)
			
			let imageUrl = photo.imageUrl
			
			if let cachedImage = imageStore.fetchedImage(withUrl: imageUrl) {
				imageCell.setImage(to: cachedImage)
			} else {
				imageCell.setImage(to: nil)
				
				imageStore.fetchImage(withUrl: imageUrl) { result in
					switch result {
					case .failure(let error):
						print(error.localizedDescription)
					case .success(let image):
						if imageCell.representedId == ObjectIdentifier(self) {
							imageCell.setImage(to: image)
						}
					}
				}
			}
		}
		return cell
	}
}
