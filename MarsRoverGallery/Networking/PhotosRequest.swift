//
//  PhotosRequest.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/6/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

enum PhotosRequestError: Error {
	case invalidCamera
}

struct PhotosRequest {
	
	enum DateOption {
		case sol(Int)
		case earthDate(Date)
		case latest
		
		var string: String {
			switch self {
			case .latest:
				return "latest_photos?"
			case .earthDate(let date):
				let dateString = NASADateFormatter.shared.string(from: date)
				return "photos?earth_date=\(dateString)"
			case .sol(let sol):
				return "photos?sol=\(sol)"
			}
		}
	}
	
	let roverName: Rover.Name
	let cameraName: Camera.Name?
	let dateOption: DateOption
	
	init(
		roverName: Rover.Name,
		cameraName: Camera.Name? = nil,
		dateOption: DateOption = .latest) throws
	{
		if let cameraName = cameraName {
			guard roverName.availableCameras.contains(cameraName) else {
				throw PhotosRequestError.invalidCamera
			}
		}
		
		self.roverName = roverName
		self.cameraName = cameraName
		self.dateOption = dateOption
	}
	
	@discardableResult
	func fetch(
		page: Int = 1,
		completion: @escaping (Result<[Photo], Error>) -> Void) -> URLSessionDataTask?
	{
		let urlString = generateUrlString(forResultsOnPage: page)
		
		guard let url = URL(string: urlString) else {
			return nil
		}
		
		let request = URLRequest(url: url)
		
		return URLSession.shared.fetch(request: request, as: PhotosResponse.self) { result in
			DispatchQueue.main.async {
				switch result {
				case .failure(let error):
					return completion(.failure(error))
				case .success(let photosResponse):
					return completion(.success(photosResponse.photos))
				}
			}
		}
	}
	
	private func generateUrlString(forResultsOnPage page: Int) -> String {
		let roverNameString = "rovers/\(roverName.rawValue.lowercased())"
		let dateOptionString = dateOption.string
		let cameraNameString: String
		if let cameraName = cameraName {
			cameraNameString = "camera=\(cameraName.rawValue.lowercased())"
		} else {
			cameraNameString = ""
		}
		
		let pageString = "page=\(page)"
		let apiKeyString = "api_key=\(Secrets.apiKey)"
		let firstSeparator = dateOptionString != DateOption.latest.string ? "&" : ""
		let secondSeparator = !cameraNameString.isEmpty ? "&" : ""
		
		let urlString = String(
			format: "%@%@%@%@%@%@%@%@%@%@%@",
			Constants.baseURLString,
			"/",
			roverNameString,
			"/",
			dateOptionString,
			firstSeparator,
			cameraNameString,
			secondSeparator,
			pageString,
			"&",
			apiKeyString)
		
		print(urlString)
		
		return urlString
	}
}
