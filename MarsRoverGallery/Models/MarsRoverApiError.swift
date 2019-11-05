//
//  MarsRoverApiError.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/5/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

enum MarsRoverApiError: Error {
	case invalidDateFormat(dateString: String)
}
