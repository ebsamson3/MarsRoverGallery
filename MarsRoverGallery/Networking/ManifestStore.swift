//
//  ManifestStore.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

class ManifestStore {
	
	private let operationQueue: OperationQueue = {
		let operationQueue = OperationQueue()
		return operationQueue
	}()
	
	private var downloadOperations = [Rover.Name: ManifestDownloadOperation]()
	
	private var manifests = [Rover.Name: Manifest]()
	
	func fetchedManifest(forRover roverName: Rover.Name) -> Manifest? {
		return manifests[roverName]
	}
	
	func fetchManifest(
		forRover roverName: Rover.Name,
		completion: @escaping (Result<Manifest, Error>) -> Void = { _ in })
	{
		if let manifest = manifests[roverName] {
			completion(.success(manifest))
		}
		
		if let previousOperation = downloadOperations[roverName] {
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
		
		let operation = ManifestDownloadOperation(roverName: roverName)
		
		operation.completionBlock = { [weak self] in
			DispatchQueue.main.async {
				self?.downloadOperations.removeValue(forKey: roverName)
				
				guard let result = operation.result else {
					return
				}
				
				if case .success(let manifest) = result {
					self?.manifests[roverName] = manifest
				}
				
				if operation.isCancelled {
					return
				}
				
				completion(result)
			}
		}
		
		downloadOperations.updateValue(operation, forKey: roverName)
		operationQueue.addOperation(operation)
	}
	
	func cancelFetch(forManifestForRover roverName: Rover.Name) {
		downloadOperations[roverName]?.cancel()
		downloadOperations.removeValue(forKey: roverName)
	}
}
