//
//  FullScreenPhotoViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/8/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

/// View model for the full screen photo image
class FullScreenPhotoViewModel {
	
	// Image store for fetching the photo
	private let imageStore: ImageStore
	
	let photo: Photo
	
	//MARK: Photo caption details
	lazy var photoDetails: [(name: String, value: String)] = [
		(name: "Photo ID", value: String(photo.id)),
		(name: "Rover", value: photo.rover.name.rawValue),
		(name: "Camera", value: photo.cameraName.fullName),
		(name: "Date Taken", value: NASADateFormatter.shared.string(from: photo.earthDate)),
		(name: "Sol Taken", value: String(photo.sol))
	]
	
	// Set the image if available, otherwise fetch then notify the view controller
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
						// If the image url changed, do not set the image.
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
	
	// Used to notify the view controller when a photo is fetched
	var didSetImage: ((UIImage) -> Void)?
	
	init(photo: Photo, imageStore: ImageStore) {
		self.photo = photo
		self.imageStore = imageStore
	}
}
