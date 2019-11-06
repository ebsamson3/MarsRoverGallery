//
//  NASADateFormatter.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/5/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

enum NASADateFormatterError: Error {
	case invalidDateFormat(dateString: String)
}

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
			throw NASADateFormatterError.invalidDateFormat(dateString: string)
		}
		return date
	}
	
	func string(from date: Date) -> String {
		return dateFormatter.string(from: date)
	}
}
