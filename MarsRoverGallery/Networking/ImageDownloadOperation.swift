//
//  ImageDownloadOperation.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/7/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

enum ImageDownloadOperationError: Error {
	case imageRead
}

class ImageDownloadOperation: AsynchronousOperation {
	
	let imageUrl: String
	var result: Result<UIImage, Error>?
	
	init(imageUrl: String) {
		self.imageUrl = imageUrl
	}
	
	override func main() {
		
		let session = URLSession.shared
		
		guard let url = URL(string: imageUrl) else {
			self.finish()
			return
		}
		
		let request = URLRequest(url: url)
		
		if isCancelled {
			return
		}
		
		session.dataTask(with: request) { [weak self] data, response, error in
			
			if let error = error {
				self?.result = .failure(error)
				self?.finish()
				return
			}
			
			if
				let statusCode = (response as? HTTPURLResponse)?.statusCode,
				statusCode != 200
			{
				self?.result = .failure(URLSessionError.badResponse(code: statusCode))
				self?.finish()
				return
			}
			
			guard let data = data else {
				self?.result = .failure(URLSessionError.nilData)
				self?.finish()
				return
			}
			
			guard let image = UIImage(data: data) else {
				self?.result = .failure(ImageDownloadOperationError.imageRead)
				self?.finish()
				return
			}
			
			self?.result = .success(image)
			self?.finish()
		}.resume()
	}
}

extension ImageDownloadOperation: URLSessionDataDelegate {
	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		if isCancelled {
			self.finish()
		}
	}
}
