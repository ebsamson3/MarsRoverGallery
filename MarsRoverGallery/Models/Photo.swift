//
//  Photo.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/5/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

/// Models the photo object returned by the NASA Mars Rover API
struct Photo {
	
	let id: Int
	let sol: Int
	let cameraName: Camera.Name
	let imageUrl: String
	let earthDate: Date
	let rover: Rover
	var size: CGSize?
}

extension Photo: Decodable {
	enum CodingKeys: String, CodingKey {
		case id
		case sol
		case camera
		case imageUrl = "img_src"
		case earthDate = "earth_date"
		case rover
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let dateFormatter = NASADateFormatter.shared
		
		id = try container.decode(Int.self, forKey: .id)
		sol = try container.decode(Int.self, forKey: .sol)
		
		let camera = try container.decode(Camera.self, forKey: .camera)
		self.cameraName = camera.name
		
		self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
		
		let earthDateString = try container.decode(String.self, forKey: .earthDate)
		earthDate = try dateFormatter.date(from: earthDateString)
		
		self.rover = try container.decode(Rover.self, forKey: .rover)
	}
}
