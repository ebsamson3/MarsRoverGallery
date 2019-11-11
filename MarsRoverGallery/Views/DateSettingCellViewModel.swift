//
//  SliderCellViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

/// Configures a slider cell for selecting the photo request sol
class DateSettingCellViewModel {
	
	private let dateFormatter = NASADateFormatter.shared
	
	// Observable properties, when they are changed the slider cell will be notified
	private var _isLoading = CoalescingObservable<Bool>(false)
	private var _valueString = CoalescingObservable<String>("Loading manifest")
	private var _currentPercentMax = CoalescingObservable<Float>(1)
	
	// Current position of the slider relative to the max value. Convenient access point for the observable's value
	private var currentPercentMax: Float {
		get {
			return _currentPercentMax.value
		} set {
			_currentPercentMax.value = newValue
		}
	}
	
	// Mission manifest which sets the bounds for our date selection
	var manifest: Manifest? {
		didSet {
			didSetManifest()
		}
	}
	
	// Current date selection
	private var currentValue = PhotosRequest.DateOption.latest
	
	init(manifest: Manifest? = nil) {
		defer {
			self.manifest = manifest
		}
	}
	
	/// On manifest set, change the laoding status and update the slider to relect it's now known bounds
	private func didSetManifest() {
		
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
	
	/// On slider change, update the current value and the value string that indicates the selected value to the user
	private func handleSliderCellValueDidChange(_ value: Float) {
		currentValue = getValue(forCurrentPercentMax: value)
		setValueString(forValue: currentValue)
	}
	
	/// Gets the current date selection
	func getCurrentValue() -> PhotosRequest.DateOption {
		return currentValue
	}
	
	/// Sets the current date selection in units of Sol, updates the slider position and value string
	func setCurrentValue(to value: PhotosRequest.DateOption) {
		
		if let sol = getSol(fromValue: value) {
			currentValue = .sol(sol)
		} else {
			currentValue = value
		}
		setCurrentPercentMax()
		setValueString(forValue: currentValue)
	}
	
	/// Convert the current value to sol if neccesary and then set the value string based on the current sol
	private func setValueString(forValue value: PhotosRequest.DateOption) {
		guard manifest != nil else {
			_valueString.value = "Loading manifest"
			return
		}
		
		guard let sol = getSol(fromValue: value) else {
			return
		}
		
		_valueString.value = "Sol \(sol)"
	}
	
	/// Sets the position of the slider relative to the maximum value, accounting for situations where the new slider value might exceed the current maximum or minimum bounds
	private func setCurrentPercentMax() {
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
	
	/// Converts the arbitrary slider value to sol
	private func getValue(forCurrentPercentMax currentPercentMax: Float) -> PhotosRequest.DateOption {
		guard let manifest = manifest else {
			return .latest
		}
		return .sol(Int(currentPercentMax * Float(manifest.maxSol)))
	}
	
	/// Converts any photos request date option type to the corresponding sol
	private func getSol(fromValue value: PhotosRequest.DateOption) -> Int? {
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

extension DateSettingCellViewModel: ItemRepresentable {
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
			
			//MARK: Bind observer to observable view model values
			
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
