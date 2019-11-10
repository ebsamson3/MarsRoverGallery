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
	case invalidDateFromSol(sol: Int)
}

class NASADateFormatter {
	
	static let shared = NASADateFormatter()
	
	private let calendar: Calendar = {
		var calendar = Calendar.current
		if let timeZone = TimeZone(abbreviation: "CST") {
			calendar.timeZone = timeZone
		}
		return calendar
	}()
	
	private lazy var dateFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.calendar = calendar
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
	
	func date(fromSol sol: Int, andLandingDate landingDate: Date, andRover roverName: Rover.Name) throws -> Date {
		
		let days = Int(Double(sol) * 1.02749125)
		
		let hours: Int
		let minutes: Int
		
		switch roverName {
		case .spirit:
			hours = 4
			minutes = 35
		case .opportunity:
			hours = 5
			minutes = 5
		case .curiosity:
			hours = 0
			minutes = 32
		}
		
		let dateComponents = DateComponents(day: days, hour: hours, minute: minutes)
		guard let earthDate = calendar.date(byAdding: dateComponents, to: landingDate) else {
			throw NASADateFormatterError.invalidDateFromSol(sol: sol)
		}
		return earthDate
	}
	
	func string(fromSol sol: Int, andLandingDate landingDate: Date, andRover roverName: Rover.Name) throws -> String {
		let dateFromSol = try date(fromSol: sol, andLandingDate: landingDate, andRover: roverName)
		return string(from: dateFromSol)
	}
}
