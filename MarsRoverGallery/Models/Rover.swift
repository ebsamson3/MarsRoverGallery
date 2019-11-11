//
//  Rover.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/4/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

/// Models the rover object returned as a photo element in the NASA API
struct Rover {
	
	let id: Int
	let name: Rover.Name
	let landingDate: Date
	let launchDate: Date
	let status: String
	let maxSol: Int
	let maxDate: Date
	let totalPhotos: Int
}

extension Rover {

	/// Enum of each specific rover with a variable that denotes their available cameras 
	enum Name: String, Codable, CaseIterable {
		case curiosity = "Curiosity"
		case opportunity = "Opportunity"
		case spirit = "Spirit"
		
		var availableCameras: Set<Camera.Name> {
			switch self {
			case .curiosity:
				return [.any, .fhaz, .rhaz, .mast, .chemcam, .mahli, .mardi, .navcam]
			case .opportunity, .spirit:
				return [.any, .fhaz, .rhaz, .pancam, .minites]
			}
		}
	}
}

extension Rover: Decodable {
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case landingDate = "landing_date"
		case launchDate = "launch_date"
		case status
		case maxSol = "max_sol"
		case maxDate = "max_date"
		case totalPhotos = "total_photos"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let dateFormatter = NASADateFormatter.shared
		
		id = try container.decode(Int.self, forKey: .id)
		name = try container.decode(Rover.Name.self, forKey: .name)
		
		let landingDateString = try container.decode(String.self, forKey: .landingDate)
		landingDate = try dateFormatter.date(from: landingDateString)
		
		let launchDateString = try container.decode(String.self, forKey: .launchDate)
		launchDate = try dateFormatter.date(from: launchDateString)
		
		status = try container.decode(String.self, forKey: .status)
		maxSol = try container.decode(Int.self, forKey: .maxSol)
		
		let maxDateString = try container.decode(String.self, forKey: .launchDate)
		maxDate = try dateFormatter.date(from: maxDateString)

		totalPhotos = try container.decode(Int.self, forKey: .totalPhotos)
	}
}
