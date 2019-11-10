//
//  SliderCellViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class SliderCellViewModel {
	
	enum DateSetting: String, CaseIterable {
		case sol = "Sol"
		case earthDate = "Earth Date"
	}
	
	let dateFormatter = NASADateFormatter.shared
	
	var manifest: Manifest? {
		didSet {
			didSetManifest()
		}
	}
	
	var dateSetting = DateSetting.sol {
		didSet {
			setValueString(forValue: currentValue)
		}
	}
	
	private var _isLoading = CoalescingObservable<Bool>(false)
	private var _valueString = CoalescingObservable<String>("Latest")
	private var _maximumValue = CoalescingObservable<Float>(100)
	private lazy var currentValue = _maximumValue.value
	
	init(manifest: Manifest? = nil) {
		defer {
			self.manifest = manifest
		}
	}
	
	func didSetManifest() {
		guard let manifest = manifest else {
			_isLoading.value = true
			return
		}
		_isLoading.value = false
		_maximumValue.value = Float(manifest.maxSol)
	}
	
	func handleSliderCellValueDidChange(_ value: Float) {
		currentValue = value
		setValueString(forValue: value)
	}
	
	func setValueString(forValue value: Float) {
		print(currentValue)
		print(_maximumValue.value)
		
		if value == _maximumValue.value {
			_valueString.value = "Latest"
		}
		
		switch dateSetting {
		case .sol:
			_valueString.value = "Sol: \(Int(value))"
		case .earthDate:
			guard
				let landingDate = manifest?.landingDate,
				let roverName = manifest?.roverName,
				let dateString = try? dateFormatter.string(fromSol: Int(value), andLandingDate: landingDate, andRover: roverName)
			else {
				return
			}
			_valueString.value = dateString
		}
	}
}

extension SliderCellViewModel: CellRepresentable {
	static func registerCell(tableView: UITableView) {
		tableView.register(
			SliderCell.self,
			forCellReuseIdentifier: SliderCell.reuseIdentifier)
	}

	func cellInstance(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(
			withIdentifier: SliderCell.reuseIdentifier,
			for: indexPath)

		return cell
	}
}

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
			sliderCell.currentValue = currentValue
			sliderCell.handleSliderValueDidChange = handleSliderCellValueDidChange(_:)
			
			sliderCell.observe(_isLoading, options: [.initial]) { [weak sliderCell] (isLoading, _) in
				sliderCell?.isLoading = isLoading
			}
			
			sliderCell.observe(_maximumValue, options: [.initial]) { [weak sliderCell] (maximumValue, _) in
				
				sliderCell?.maximumValue = maximumValue
				
				if let currentValue = sliderCell?.currentValue,
					currentValue > maximumValue
				{
					sliderCell?.currentValue = maximumValue
				}
			}
			
			sliderCell.observe(_valueString, options: [.initial]) { [weak sliderCell] (valueString, _) in
				sliderCell?.valueString = valueString
			}
		}
		
		return cell
	}
	
	
}
