//
//  PaginatedPhotosController.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/6/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

enum PaginatedPhotosControllerError: LocalizedError {
	case nilRequest
	
	var errorDescription: String? {
		switch self {
		case .nilRequest:
			return "No request set for paginated photos controller"
		}
	}
}

protocol PaginatedPhotosControllerDelegate: class {
	func photosController(statusDidChangeTo status: PaginatedPhotosController.Status)
}

/// Executes NASA mars rover photo requests in a paginated manner
class PaginatedPhotosController {
	
	/// States a paginated photos controller can be in
	enum Status {
		case upToDate(latestResults: [Photo], nextPage: Int)
		case loading(task: URLSessionDataTask)
		case error(Error)
		case finished(latestResults: [Photo])
		
		static let initial: Self = .upToDate(latestResults: [], nextPage: 1)
	}
	
	//MARK: Read-only variables
	
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
	
	//MARK: Parameters
	
	// Wrapped photo request. Whenver a new request is set all request and data from the old request are scrubbed
	var photosRequest: PhotosRequest? {
		didSet {
			if case .loading(let task) = status {
				task.cancel()
			}
			_status = photosRequest != nil ? .initial : .finished(latestResults: [])
			_photos = []
		}
	}
	
	weak var delegate: PaginatedPhotosControllerDelegate?
	
	//MARK: Lifecycle
	
	init(photosRequest: PhotosRequest? = nil) {
		self.photosRequest = photosRequest
	}
	
	//MARK: Fetch methods
	
	/// Fetches the next page of a photo request
	/// - Throws: `PaginatedPhotosControllerError.nilRequest`
	func fetchNextPage(
		completion: @escaping (Result<[Photo], Error>) -> Void = {_ in })
	{
		guard let photosRequest = photosRequest else {
			completion(.failure(PaginatedPhotosControllerError.nilRequest))
			return
		}
		
		let requestId = photosRequest.id
		
		// Only fetch if previous fetch was completed and request isn't finished
		guard case .upToDate(_, let nextPage) = status else {
			return
		}
		
		// Data task for fetching the next page of a paginated request
		let task = photosRequest.fetch(page: nextPage) { [weak self] result in
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success(let newPhotos):
				
				var sizedPhotos = newPhotos
				
				let imageUrlstrings = newPhotos.map { $0.imageUrl }
				
				// Sizes photos using an image sizer
				ImageSizer.size(imageUrlStrings: imageUrlstrings) { sizes in
					
					for index in 0..<sizedPhotos.count {
						sizedPhotos[index].size = sizes[sizedPhotos[index].imageUrl]
					}
					
					// If the photo request changed mid-fetch, do not return the previous reqeuest's results
					guard self?.photosRequest?.id == requestId else {
						return
					}
					
					// Filter the sized photos for any photo images that are too small. This helps remove any corrupted images
					let filteredPhotos = sizedPhotos.filter { photo in
						guard
							let width = photo.size?.width,
							let height = photo.size?.height
						else {
							return false
						}
						return width > 200 || height > 200
					}
					
					// Add filtered photos to the stored photos of the request
					self?._photos.append(contentsOf: filteredPhotos)
					
					// If less than 25 results were returned in the last request, the request returned less than the maximum number of photos so we now it is finished
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
