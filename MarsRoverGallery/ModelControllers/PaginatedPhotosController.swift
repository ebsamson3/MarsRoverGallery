//
//  PaginatedPhotosController.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/6/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

protocol PaginatedPhotosControllerDelegate: class {
	func photosController(statusDidChangeTo status: PaginatedPhotosController.Status)
}

class PaginatedPhotosController {
	
	enum Status {
		case upToDate(latestResults: [Photo], nextPage: Int)
		case loading(page: Int, task: URLSessionDataTask)
		case error(Error)
		case finished
		
		static let initial: Self = .upToDate(latestResults: [], nextPage: 1)
	}
	
	var photosRequest: PhotosRequest {
		didSet {
			if case .loading(_, let task) = status {
				task.cancel()
			}
			_status = .initial
			_photos = []
		}
	}
	
	private var _photos = [Photo]()
	private var _status: Status = .initial {
		didSet {
			delegate?.photosController(statusDidChangeTo: _status)
		}
	}
	
	var photos: [Photo] {
		return _photos
	}
	
	var status: Status {
		return _status
	}
	
	weak var delegate: PaginatedPhotosControllerDelegate?
	
	init(photosRequest: PhotosRequest) {
		self.photosRequest = photosRequest
	}
	
	func fetchNextPage(
		completion: @escaping (Result<[Photo], Error>) -> Void = {_ in })
	{
		let requestId = photosRequest.id
		
		guard case .upToDate(_, let nextPage) = status else {
			return
		}
		
		let task = photosRequest.fetch(page: nextPage) { [weak self] result in
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success(let newPhotos):
				
				var sizedPhotos = newPhotos
				
				let imageUrlstrings = newPhotos.map { $0.imageUrl }
				
				ImageSizer.size(imageUrlStrings: imageUrlstrings) { sizes in
					
					for index in 0..<sizedPhotos.count {
						sizedPhotos[index].size = sizes[sizedPhotos[index].imageUrl]
					}
					
					guard self?.photosRequest.id == requestId else {
						return
					}
					
					self?._photos.append(contentsOf: sizedPhotos)
					
					self?._status = sizedPhotos.count < 25 ?
						.finished : .upToDate(latestResults: sizedPhotos, nextPage: nextPage + 1)
					
					completion(.success(sizedPhotos))
				}
			}
		}
		
		if let task = task {
			_status = .loading(page: nextPage, task: task)
		}
	}
}
