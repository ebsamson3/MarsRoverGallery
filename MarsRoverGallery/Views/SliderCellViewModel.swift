//
//  SliderCellViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class SliderCellViewModel {
	
	private let dateFormatter = NASADateFormatter.shared
	private lazy var calendar = dateFormatter.calendar
	
	private var _isLoading = CoalescingObservable<Bool>(false)
	private var _valueString = CoalescingObservable<String>("Loading manifest")
	private var _currentPercentMax = CoalescingObservable<Float>(1)
	
	var manifest: Manifest? {
		didSet {
			didSetManifest()
		}
	}
	
	private var currentValue = PhotosRequest.DateOption.latest 
	
	private var currentPercentMax: Float {
		get {
			return _currentPercentMax.value
		} set {
			_currentPercentMax.value = newValue
		}
	}
	
	init(manifest: Manifest? = nil) {
		defer {
			self.manifest = manifest
		}
	}
	
	func didSetManifest() {
		
		guard manifest != nil else {
			_valueString.value = "Loading manifest..."
			_isLoading.value = true
			return
		}
		
		_isLoading.value = false
		
		if let value = getSol(fromValue: currentValue) {
			currentValue = .sol(value)
		}
		
		setCurrentPercentMax()
		setValueString(forValue: currentValue)
	}
	
	func handleSliderCellValueDidChange(_ value: Float) {
		currentValue = getValue(forCurrentPercentMax: value)
		setValueString(forValue: currentValue)
	}
	
	func getCurrentValue() -> PhotosRequest.DateOption {
		return currentValue
	}
	
	func setCurrentValue(to value: PhotosRequest.DateOption) {
		
		if let sol = getSol(fromValue: value) {
			currentValue = .sol(sol)
		} else {
			currentValue = value
		}
		setCurrentPercentMax()
		setValueString(forValue: currentValue)
	}
	
	func setValueString(forValue value: PhotosRequest.DateOption) {
		guard manifest != nil else {
			_valueString.value = "Loading manifest"
			return
		}
		
		guard let sol = getSol(fromValue: value) else {
			return
		}
		
		_valueString.value = "Sol \(sol)"
	}
	
	func setCurrentPercentMax() {
		guard let manifest = manifest else {
			currentPercentMax = 1.0
			return
		}
		
		guard let sol = getSol(fromValue: currentValue) else {
			currentPercentMax = 1.0
			return
		}
		
		let solPercentMax = Float(sol) / Float(manifest.maxSol)
		if solPercentMax > 1 {
			currentValue = .sol(manifest.maxSol)
			currentPercentMax = 1
		} else {
			currentPercentMax = solPercentMax
		}
	}
	
	func getValue(forCurrentPercentMax currentPercentMax: Float) -> PhotosRequest.DateOption {
		guard let manifest = manifest else {
			return .latest
		}
		return .sol(Int(currentPercentMax * Float(manifest.maxSol)))
	}
	
	func getSol(fromValue value: PhotosRequest.DateOption) -> Int? {
		guard let manifest = manifest else {
			return nil
		}
		
		switch value {
		case .latest:
			return manifest.maxSol
		case .sol(let sol):
			return sol
		case .earthDate(let date):
			guard date > manifest.landingDate else {
				return 0
			}
			
			guard let sol = try? dateFormatter.sol(
				fromDate: date,
				andLandingDate: manifest.landingDate) else {
				return nil
			}
			return sol
		}
	}
}
//
//extension SliderCellViewModel: CellRepresentable {
//	static func registerCell(tableView: UITableView) {
//		tableView.register(
//			SliderCell.self,
//			forCellReuseIdentifier: SliderCell.reuseIdentifier)
//	}
//
//	func cellInstance(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
//		let cell = tableView.dequeueReusableCell(
//			withIdentifier: SliderCell.reuseIdentifier,
//			for: indexPath)
//
//		return cell
//	}
//}

extension SliderCellViewModel: ItemRepresentable {
	static func registerCell(collectionView: UICollectionView) {
		collectionView.register(
			SliderCell.self,
			forCellWithReuseIdentifier: SliderCell.reuseIdentifier)
	}
	
	func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: SliderCell.reuseIdentifier,
			for: indexPath)
		
		if let sliderCell = cell as? SliderCell {
			sliderCell.handleSliderValueDidChange = handleSliderCellValueDidChange(_:)
			
			sliderCell.observe(_isLoading, options: [.initial]) { [weak sliderCell] (isLoading, _) in
				sliderCell?.isLoading = isLoading
			}
			
			sliderCell.observe(_valueString, options: [.initial]) { [weak sliderCell] (valueString, _) in
				sliderCell?.valueString = valueString
			}
			
			sliderCell.observe(_currentPercentMax, options: [.initial]) { [weak sliderCell] (currentPercentMax, _) in
				sliderCell?.currentValue = currentPercentMax
			}
		}
		
		return cell
	}
	
	
}
