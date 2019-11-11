//
//  ImageStore.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/7/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

/// An image store that asyncronously loads images
class ImageStore {
	
	// Loaded images are cached for later use
	private let imageCache: NSCache<NSString, UIImage> = {
		let cache = NSCache<NSString, UIImage>()
		return cache
	}()
	
	// The queue that runs all of our iamge loads
	private let operationQueue: OperationQueue = {
		let operationQueue = OperationQueue()
		return operationQueue
	}()

	// Stores active operations so they an be cancelled or added onto
	private var downloadOperations = [String: ImageDownloadOperation]()
	
	/// Fetches image from cache if availiable
	func fetchedImage(withUrl imageUrl: String) -> UIImage? {
		return imageCache.object(forKey: imageUrl as NSString)
	}
	
	/// Fetch image and store in cache
	func fetchImage(
		withUrl imageUrl: String,
		completion: @escaping (Result<UIImage, Error>) -> Void = {_ in })
	{
		// Check if image in cache alreday to save on effort
		if let image = fetchedImage(withUrl: imageUrl) {
			completion(.success(image))
			return
		}
		
		// Adds a new completion to an older operation for the same URL instead of wastefully starting a duplicate fetch
		if let previousOperation = downloadOperations[imageUrl] {
			let adapterOperation = BlockOperation {
				
				guard !previousOperation.isCancelled else {
					return
				}
				
				guard let result = previousOperation.result else {
					return
				}
				DispatchQueue.main.async {
					completion(result)
				}
			}
			
			adapterOperation.addDependency(previousOperation)
			operationQueue.addOperation(adapterOperation)
			return
		}
		
		let operation = ImageDownloadOperation(imageUrl: imageUrl)
		
		// Caches the image when the operation completes, notifies the fetcher
		operation.completionBlock = { [weak self] in
			
			DispatchQueue.main.async {
				self?.downloadOperations.removeValue(forKey: imageUrl)
				
				guard let result = operation.result else {
					return
				}
				
				if case .success(let image) = result {
					self?.imageCache.setObject(image, forKey: imageUrl as NSString)
				}
				
				if operation.isCancelled {
					return
				}
				
				completion(result)
			}
		}
		
		downloadOperations.updateValue(operation, forKey: imageUrl)
		operationQueue.addOperation(operation)
	}
	
	/// Cancels an image fetch for a given url
	func cancelFetch(forImageWithUrl imageUrl: String) {
		downloadOperations[imageUrl]?.cancel()
		downloadOperations.removeValue(forKey: imageUrl)
	}
	
	/// Clears the image store's cache
	func removeAllObjects() {
		imageCache.removeAllObjects()
	}
}
