//
//  ImageStore.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/7/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class ImageStore {
	
	private let imageCache: NSCache<NSString, UIImage> = {
		let cache = NSCache<NSString, UIImage>()
		return cache
	}()
	
	private let operationQueue: OperationQueue = {
		let operationQueue = OperationQueue()
		return operationQueue
	}()

	private var downloadOperations = [String: ImageDownloadOperation]()
	
	func fetchedImage(withUrl imageUrl: String) -> UIImage? {
		return imageCache.object(forKey: imageUrl as NSString)
	}
	
	func fetchImage(
		withUrl imageUrl: String,
		completion: @escaping (Result<UIImage, Error>) -> Void = {_ in })
	{
		if let image = fetchedImage(withUrl: imageUrl) {
			completion(.success(image))
			return
		}
		
		if let previousOperation = downloadOperations[imageUrl] {
			let adapterOperation = BlockOperation {
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
	
	func cancelFetch(forImageWithUrl imageUrl: String) {
		downloadOperations[imageUrl]?.cancel()
		downloadOperations.removeValue(forKey: imageUrl)
	}
	
	func removeAllObjects() {
		imageCache.removeAllObjects()
	}
}
