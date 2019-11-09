//
//  FullScreenPhotoViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/8/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class FullScreenPhotoViewModel {
	
	private let imageStore: ImageStore
	
	let photo: Photo
	
	lazy var photoDetails: [(name: String, value: String)] = [
		(name: "Photo ID", value: String(photo.id)),
		(name: "Rover", value: photo.rover.name.rawValue),
		(name: "Camera", value: photo.cameraName.fullName),
		(name: "Date Taken", value: NASADateFormatter.shared.string(from: photo.earthDate)),
		(name: "Sol Taken", value: String(photo.sol))
	]
	
	var image: UIImage? {
		get {
			let imageUrl = photo.imageUrl
			if let image = imageStore.fetchedImage(withUrl: imageUrl) {
				return image
			} else {
				imageStore.fetchImage(withUrl: photo.imageUrl) { [weak self] result in
					switch result {
					case .failure(let error):
						print(error.localizedDescription)
					case .success(let image):
						guard imageUrl == self?.photo.imageUrl else {
							return
						}
						self?.didSetImage?(image)
					}
				}
				return nil
			}
		}
	}
	
	var didSetImage: ((UIImage) -> Void)?
	
	init(photo: Photo, imageStore: ImageStore) {
		self.photo = photo
		self.imageStore = imageStore
	}
}
