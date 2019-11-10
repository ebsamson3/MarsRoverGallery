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
	case invalidSolFromDate(date: Date)
	case invalidDateFromComponents
}

class NASADateFormatter {
	
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
	
	func date(from string: String) throws -> Date {
		guard let date =  dateFormatter.date(from: string) else {
			throw NASADateFormatterError.invalidDateFormat(dateString: string)
		}
		return date
	}
	
	func string(from date: Date) -> String {
		return dateFormatter.string(from: date)
	}
	
	func date(fromSol sol: Int, andLandingDate landingDate: Date) throws -> Date {
		return try date(fromSol: Double(sol), andLandingDate: landingDate)
	}
	
	func date(fromSol sol: Double, andLandingDate landingDate: Date) throws -> Date {
		let days = Int(round(sol * 1.02749125))
		
		let dateComponents = DateComponents(day: days)
		guard let earthDate = calendar.date(byAdding: dateComponents, to: start(of: landingDate)) else {
			throw NASADateFormatterError.invalidDateFromSol(sol: Int(sol))
		}
		return earthDate
	}
	
	func sol(fromDate date: Date, andLandingDate landingDate: Date) throws -> Int {
		let startOfLandingDate = start(of: landingDate)
		let startOfDate = start(of: date)
		
		guard let numberOfDays = calendar.dateComponents([.day], from: startOfLandingDate, to: startOfDate).day else {
			throw NASADateFormatterError.invalidSolFromDate(date: date)
		}
		
		let sol = Int(round(Double(numberOfDays) / 1.02749125))
		return sol
	}
	
	func string(fromSol sol: Int, andLandingDate landingDate: Date) throws -> String {
		let dateFromSol = try date(fromSol: sol, andLandingDate: landingDate)
		return string(from: dateFromSol)
	}
	
	func start(of date: Date) -> Date {
		 let unitFlags = Set<Calendar.Component>([.year, .month, .day])
		 let components = calendar.dateComponents(unitFlags, from: date)
		 return calendar.date(from: components)!
	}
}
