//
//  ManifestDownloadOperation.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

class ManifestDownloadOperation: AsynchronousOperation {
	
	let rover: Rover.Name
	private var _result = ThreadSafe<Result<Manifest, Error>?>(value: nil)
	
	init(rover: Rover.Name) {
		self.rover = rover
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
		
		
		
	}
}
