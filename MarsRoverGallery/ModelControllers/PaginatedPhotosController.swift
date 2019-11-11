//
//  PaginatedPhotosController.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/6/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

enum PaginatedPhotosControllerError: Error {
	case nilRequest
}

protocol PaginatedPhotosControllerDelegate: class {
	func photosController(statusDidChangeTo status: PaginatedPhotosController.Status)
}

class PaginatedPhotosController {
	
	enum Status {
		case upToDate(latestResults: [Photo], nextPage: Int)
		case loading(task: URLSessionDataTask)
		case error(Error)
		case finished(latestResults: [Photo])
		
		static let initial: Self = .upToDate(latestResults: [], nextPage: 1)
	}
	
	var photosRequest: PhotosRequest? {
		didSet {
			if case .loading(let task) = status {
				task.cancel()
			}
			_status = photosRequest != nil ? .initial : .finished(latestResults: [])
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
	
	init(photosRequest: PhotosRequest? = nil) {
		self.photosRequest = photosRequest
	}
	
	func fetchNextPage(
		completion: @escaping (Result<[Photo], Error>) -> Void = {_ in })
	{
		guard let photosRequest = photosRequest else {
			completion(.failure(PaginatedPhotosControllerError.nilRequest))
			return
		}
		
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
					
					guard self?.photosRequest?.id == requestId else {
						return
					}
					
					let filteredPhotos = sizedPhotos.filter { photo in
						guard
							let width = photo.size?.width,
							let height = photo.size?.height
						else {
							return false
						}
						
						return width > 100 && height > 100
					}
					
					self?._photos.append(contentsOf: filteredPhotos)
					
					self?._status = sizedPhotos.count < 25 ?
						.finished(latestResults: filteredPhotos) :
						.upToDate(latestResults: filteredPhotos, nextPage: nextPage + 1)
					
					completion(.success(filteredPhotos))
				}
			}
		}
		
		if let task = task {
			_status = .loading(task: task)
		}
	}
}
