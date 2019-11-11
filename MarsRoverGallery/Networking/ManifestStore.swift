//
//  ManifestStore.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

/// An store that asyncronously loads mission manifests
class ManifestStore {
	
	private let operationQueue: OperationQueue = {
		let operationQueue = OperationQueue()
		return operationQueue
	}()
	
	// Holds image operations so that they can be cancelled or added onto
	private var downloadOperations = [Rover.Name: ManifestDownloadOperation]()
	
	private var manifests = [Rover.Name: Manifest]()
	
	/// Retrieves a previously fetched manifest if it exists locally
	func fetchedManifest(forRover roverName: Rover.Name) -> Manifest? {
		return manifests[roverName]
	}
	
	/// Asynchronously fetches a mission manifest for the specified rover
	func fetchManifest(
		forRover roverName: Rover.Name,
		completion: @escaping (Result<Manifest, Error>) -> Void = { _ in })
	{
		// Attempts to use a local version if available
		if let manifest = manifests[roverName] {
			completion(.success(manifest))
		}
		
		// Adds a new completion to an older operation for the same URL instead of wastefully starting a duplicate fetch
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
		
		// Stores the manifest when the operation completes, notifies the fetcher
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
	
	/// Cancels the manifest request for a specific rover
	func cancelFetch(forManifestForRover roverName: Rover.Name) {
		downloadOperations[roverName]?.cancel()
		downloadOperations.removeValue(forKey: roverName)
	}
}
