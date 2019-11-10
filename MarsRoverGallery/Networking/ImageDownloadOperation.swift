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
	private var _result = ThreadSafe<Result<UIImage, Error>?>(value: nil)
	private var task: URLSessionDataTask?
	
	var result: Result<UIImage, Error>? {
		get {
			return _result.getValue()
		}
		set {
			_result.setValue(to: newValue)
		}
	}
	
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
			self.finish()
			return
		}
		
		task = session.dataTask(with: request) { [weak self] data, response, error in
			
			if self?.isCancelled == true {
				self?.finish()
				return
			}
			
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
		}
		
		task?.resume()
	}
	
	override func cancel() {
		super.cancel()
		task?.cancel()
	}
}
