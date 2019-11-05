//
//  NASADateFormatter.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/5/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

class NASADateFormatter {
	
	static let shared = NASADateFormatter()
	
	private let dateFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = TimeZone(abbreviation: "CST")
		dateFormatter.dateFormat = "yyyy-MM-dd"
		return dateFormatter
	}()
	
	private init() {}
	
	func date(from string: String) throws -> Date {
		guard let date =  dateFormatter.date(from: string) else {
			throw MarsRoverApiError.invalidDateFormat(dateString: string)
		}
		return date
	}
}
