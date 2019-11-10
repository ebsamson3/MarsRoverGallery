//
//  ManifestStore.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

class ManifestStore {
	
	private var manifests = [Rover.Name: Manifest]()
	
	
	func fetchedManifest(forRover rover: Rover.Name) -> Manifest? {
		return manifests[rover]
	}
	
}
