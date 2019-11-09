//
//  PhotoDetailsViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/8/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class PhotoDetailsViewModel: TableViewModel {
	
	private lazy var photoDetailCellViewModels: [NameValuePairCellViewModel] = [
		NameValuePairCellViewModel(
			name: "Photo ID",
			value: String(photo.id)
		),
		NameValuePairCellViewModel(
			name: "Rover",
			value: photo.rover.name.rawValue
		),
		NameValuePairCellViewModel(
			name: "Camera",
			value: photo.cameraName.fullName
		),
		NameValuePairCellViewModel(
			name: "Date Taken",
			value: NASADateFormatter.shared.string(from: photo.earthDate)
		),
		NameValuePairCellViewModel(
			name: "Sol taken",
			value: String(photo.sol))
	]
	
	private var cellViewModelTypes: [CellRepresentable.Type] = [
		NameValuePairCellViewModel.self
	]
	
	private let imageStore: ImageStore
	
	let photo: Photo
	
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
	
	func registerCells(tableView: UITableView) {
		for cellViewModelType in cellViewModelTypes {
			cellViewModelType.registerCell(tableView: tableView)
		}
	}
	
	func numberOfRows(inSection section: Int) -> Int {
		return photoDetailCellViewModels.count
	}
	
	func getCellViewModel(at indexPath: IndexPath) -> CellRepresentable {
		return photoDetailCellViewModels[indexPath.row]
	}
}
