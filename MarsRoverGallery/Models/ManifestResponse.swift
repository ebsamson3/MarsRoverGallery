//
//  ManifestResponse.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/5/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

/// A model object fot he entire response of a mission manifest request to the NASA Mars Rover API
struct ManifestResponse: Decodable {
	let manifest: Manifest
	
	enum CodingKeys: String, CodingKey {
		case manifest = "photo_manifest"
	}
}
