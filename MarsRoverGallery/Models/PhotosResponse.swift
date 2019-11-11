//
//  PhotosResponse.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/5/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

/// The entire JSON object that is returned by a photos request
struct PhotosResponse {
	let photos: [Photo]
}

extension PhotosResponse: Decodable {
	enum CodingKeys: String, CodingKey {
		case photos
		case latestPhotos = "latest_photos"
	}
	
	// Depending on whether or not you fetch the latest photos or photos from a given date, the container of for the photos is named differently
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		if let photos = try container.decodeIfPresent([Photo].self, forKey: .photos) {
			self.photos = photos
		} else {
			self.photos = try container.decode([Photo].self, forKey: .latestPhotos)
		}
	}
}
