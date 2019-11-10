//
//  ManifestDownloadOperation.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

class ManifestDownloadOperation: AsynchronousOperation {
	
	let roverName: Rover.Name
	private var task: URLSessionDataTask?
	private var _result = ThreadSafe<Result<Manifest, Error>?>(value: nil)
	
	init(roverName: Rover.Name) {
		self.roverName = roverName
	}
	
	var result: Result<Manifest, Error>? {
		get {
			return _result.getValue()
		}
		set {
			_result.setValue(to: newValue)
		}
	}
	
	override func main() {
		
		if isCancelled {
			finish()
			return
		}
		
		let request = ManifestRequest(roverName: roverName)
		
		task = request.fetch { [weak self] result in
			
			if self?.isCancelled == true {
				self?.finish()
				return
			}
			
			self?.result = result
			self?.finish()
		}
		
		task?.resume()
	}
	
	override func cancel() {
		task?.cancel()
		super.cancel()
	}
}
