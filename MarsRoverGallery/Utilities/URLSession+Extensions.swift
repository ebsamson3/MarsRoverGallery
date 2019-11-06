//
//  URLSession+Extensions.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/6/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

enum URLSessionError: Error {
	case badResponse(code: Int)
	case nilData
}

extension URLSession {
	
	@discardableResult
	func fetch<T: Decodable>(
		request: URLRequest,
		as type: T.Type,
		completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask
	{
		let task = dataTask(with: request) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			
			if
				let statusCode = (response as? HTTPURLResponse)?.statusCode,
				statusCode != 200
			{
				completion(.failure(URLSessionError.badResponse(code: statusCode)))
				return
			}
			
			guard let data = data else {
				completion(.failure(URLSessionError.nilData))
				return
			}
			
			let decoder = JSONDecoder()
			
			do {
				let result = try decoder.decode(type, from: data)
				completion(.success(result))
			} catch {
				completion(.failure(error))
			}
		}
		
		task.resume()
		return task
	}
}

