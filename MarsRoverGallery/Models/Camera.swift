//
//  Camera.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/5/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

struct Camera {
	
	enum Name: String, Codable, CaseIterable {
		case any = "ANY"
		case fhaz = "FHAZ"
		case rhaz = "RHAZ"
		case mast = "MAST"
		case chemcam = "CHEMCAM"
		case mahli = "MAHLI"
		case mardi = "MARDI"
		case navcam = "NAVCAM"
		case pancam = "PANCAM"
		case minites = "MINITES"
		
		var fullName: String {
			switch self {
			case .any: return ""
			case .fhaz: return "Front Hazard Avoidance Camera"
			case .rhaz: return "Read Hazard Avoidance Camera"
			case .mast: return "Mast Camera"
			case .chemcam: return "Chemistry and Camera Complex"
			case .mahli: return "Mars Hand Lens Imager"
			case .mardi: return "Mars Descent Imager"
			case .navcam: return "Navigation Camera"
			case .pancam: return "Panorama Camera"
			case .minites: return "Miniature Thermal Explosion Spectrometer"
			}
		}
	}
	let name: Camera.Name
}

extension Camera: Decodable {
	
	enum CodingKeys: String, CodingKey {
		case name
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		name = try container.decode(Camera.Name.self, forKey: .name)
	}
}
