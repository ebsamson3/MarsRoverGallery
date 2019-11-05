//
//  Manifest.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/5/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

struct Manifest {
	
	let roverName: Rover.Name
	let landingDate: Date
	let launchDate: Date
	let status: String
	let maxSol: Int
	let maxDate: Date
	let totalPhotos: Int
	let entries: [Entry]
}

extension Manifest {
	
	struct Entry {
		let sol: Int
		let earthDate: Date
		let totalPhotos: Int
		let cameras: [Camera.Name]
	}
}

extension Manifest.Entry: Decodable {
	
	enum CodingKeys: String, CodingKey {
		case sol
		case earthDate = "earth_date"
		case totalPhotos = "total_photos"
		case cameras
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let dateFormatter = NASADateFormatter.shared
		
		sol = try container.decode(Int.self, forKey: .sol)
		
		let earthDateString = try container.decode(String.self, forKey: .earthDate)
		earthDate = try dateFormatter.date(from: earthDateString)
		
		totalPhotos = try container.decode(Int.self, forKey: .totalPhotos)
		cameras = try container.decode([Camera.Name].self, forKey: .cameras)
	}
}

extension Manifest: Decodable {
	
	enum CodingKeys: String, CodingKey {
		case roverName = "name"
		case landingDate = "landing_date"
		case launchDate = "launch_date"
		case status
		case maxSol = "max_sol"
		case maxDate = "max_date"
		case totalPhotos = "total_photos"
		case entries = "photos"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let dateFormatter = NASADateFormatter.shared
		
		roverName = try container.decode(Rover.Name.self, forKey: .roverName)
		
		let landingDateString = try container.decode(String.self, forKey: .landingDate)
		landingDate = try dateFormatter.date(from: landingDateString)
		
		let launchDateString = try container.decode(String.self, forKey: .launchDate)
		launchDate = try dateFormatter.date(from: launchDateString)
		
		status = try container.decode(String.self, forKey: .status)
		maxSol = try container.decode(Int.self, forKey: .maxSol)
		
		let maxDateString = try container.decode(String.self, forKey: .maxDate)
		maxDate = try dateFormatter.date(from: maxDateString)
		
		totalPhotos = try container.decode(Int.self, forKey: .totalPhotos)
		entries = try container.decode([Entry].self, forKey: .entries)
	}
}
