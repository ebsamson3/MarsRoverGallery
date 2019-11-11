//
//  ManifestRequest.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

/// Builds and carries out a request for a rover-specific mission manifest
struct ManifestRequest {
	
	let roverName: Rover.Name
	
	init(roverName: Rover.Name) {
		self.roverName = roverName
	}
	
	/// Starts and returns a data task for carrying out the manifest request
	@discardableResult
	func fetch(
		completion: @escaping (Result<Manifest, Error>) -> Void) -> URLSessionDataTask?
	{
		let urlString = generateUrlString()
		
		guard let url = URL(string: urlString) else {
			return nil
		}
		
		let request = URLRequest(url: url)
		
		return URLSession.shared.fetch(request: request, as: ManifestResponse.self) { result in
			DispatchQueue.main.async {
				switch result {
				case .failure(let error):
					return completion(.failure(error))
				case .success(let manifestResponse):
					return completion(.success(manifestResponse.manifest))
				}
			}
		}
	}
	 
	/// Generates the url string for the manifest request
	func generateUrlString() -> String {
		
		let manifestsString = "/manifests"
		let roverNameString = "/\(roverName.rawValue.lowercased())"
		let apiKeyString = "api_key=\(Secrets.apiKey)"
		
		let urlString = String(
			format: "%@%@%@%@%@",
			Constants.baseURLString,
			manifestsString,
			roverNameString,
			"?",
			apiKeyString
		)
		return urlString
	}
}
