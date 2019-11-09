//
//  PhotoDetailsViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/8/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class PhotoDetailsViewModel: TableViewModel {
	
	private let imageStore: ImageStore
	
	var photo: Photo
	
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
	
	func registerCells(tableView: UITableView) {}
	
	func numberOfRows(inSection section: Int) -> Int {
		0
	}
	
	func getCellViewModel(at indexPath: IndexPath) -> CellRepresentable? {
		return nil
	}
}
