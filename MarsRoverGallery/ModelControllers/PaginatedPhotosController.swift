//
//  PaginatedPhotosController.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/6/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

class PaginatedPhotosController {
	
	enum Status {
		case upToDate(nextPage: Int)
		case loading(page: Int, task: URLSessionDataTask)
		case error(Error)
		case finished
		
		static let initial: Self = .upToDate(nextPage: 1)
	}
	
	var photosRequest: PhotosRequest {
		didSet {
			if case .loading(_, let task) = _status {
				task.cancel()
			}
			_status = .initial
		}
	}
	
	private var _photos = [Photo]()
	private var _status: Status = .initial
	
	var photos: [Photo] {
		return _photos
	}
	
	var status: Status {
		return _status
	}
	
	init(photosRequest: PhotosRequest) {
		self.photosRequest = photosRequest
	}
	
	func fetchNextPage(
		completion: @escaping (Result<[Photo], Error>) -> Void = {_ in })
	{
		guard case .upToDate(let nextPage) = status else {
			return
		}
		
		let task = photosRequest.fetch(page: nextPage) { [weak self] result in
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success(let newPhotos):
				self?._photos.append(contentsOf: newPhotos)
				self?._status = newPhotos.count < 25 ? .finished : .upToDate(nextPage: nextPage + 1)
				completion(.success(newPhotos))
			}
		}
		
		if let task = task {
			_status = .loading(page: nextPage, task: task)
		}
	}
}
