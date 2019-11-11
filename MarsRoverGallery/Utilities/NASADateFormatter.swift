//
//  NASADateFormatter.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/5/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

enum NASADateFormatterError: LocalizedError {
	case invalidDateFormat(dateString: String)
	case invalidDateFromSol(sol: Int)
	case invalidSolFromDate(date: Date)
	
	var errorDescription: String? {
		switch self {
		case .invalidDateFormat(let dateString):
			return "Date string: \(dateString) is not in the NASA API format"
		case .invalidDateFromSol(let sol):
			return "Unable to convert sol: \(sol) to a valid earth date"
		case .invalidSolFromDate(let date):
			return "Unable to convert date: \(date) into a valid martian sol"
		}
	}
}

/// Handles functions related to NASA Mars rover date conversion
class NASADateFormatter {
	
	// Date formatters are expensive, so we implement a shared formatter for our entire app
	static let shared = NASADateFormatter()
	
	let calendar: Calendar = {
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
	
	/// Converts a string formatted in the style of the NASA mars rover API into the corresponding date
	/// - Throws: `NASADateFormatterError.invalidDateFormat(dateString: String)`
	func date(from string: String) throws -> Date {
		guard let date =  dateFormatter.date(from: string) else {
			throw NASADateFormatterError.invalidDateFormat(dateString: string)
		}
		return date
	}
	
	/// Converts a date to the NASA Api string format
	func string(from date: Date) -> String {
		return dateFormatter.string(from: date)
	}
	
	/// Converta  date in sol for a given mars rover mission to a date in earth days
	/// - Throws: `NASADateFormatterError.invalidDateFromSol(sol: Int)`
	func date(fromSol sol: Int, andLandingDate landingDate: Date) throws -> Date {
		return try date(fromSol: Double(sol), andLandingDate: landingDate)
	}
	
	/// Converta  date in sol for a given mars rover mission to a date in earth days
	/// - Throws: `NASADateFormatterError.invalidDateFromSol(sol: Int)`
	func date(fromSol sol: Double, andLandingDate landingDate: Date) throws -> Date {
		let days = Int(round(sol * 1.02749125))
		
		let dateComponents = DateComponents(day: days)
		guard let earthDate = calendar.date(byAdding: dateComponents, to: start(of: landingDate)) else {
			throw NASADateFormatterError.invalidDateFromSol(sol: Int(sol))
		}
		return earthDate
	}
	
	/// Coverts an earth date to sol for a given mars rover mission
	/// - Throws: `NASADateFormatterError.invalidSolFromDate(date: Date)`
	func sol(fromDate date: Date, andLandingDate landingDate: Date) throws -> Int {
		let startOfLandingDate = start(of: landingDate)
		let startOfDate = start(of: date)
		
		guard let numberOfDays = calendar.dateComponents([.day], from: startOfLandingDate, to: startOfDate).day else {
			throw NASADateFormatterError.invalidSolFromDate(date: date)
		}
		
		let sol = Int(round(Double(numberOfDays) / 1.02749125))
		return sol
	}
	
	/// Convers a date in sol for a given mars mission to the corresponding earth date
	/// - Throws:`NASADateFormatterError.invalidDateFromSol(sol: Int)`
	func dateString(fromSol sol: Int, andLandingDate landingDate: Date) throws -> String {
		let dateFromSol = try date(fromSol: sol, andLandingDate: landingDate)
		return string(from: dateFromSol)
	}
	
	/// Finds the start of a date given a calendar in the NASA time zone
	func start(of date: Date) -> Date {
		 let unitFlags = Set<Calendar.Component>([.year, .month, .day])
		 let components = calendar.dateComponents(unitFlags, from: date)
		 return calendar.date(from: components)!
	}
}
