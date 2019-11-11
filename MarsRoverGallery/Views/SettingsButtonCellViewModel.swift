//
//  SettingsButtonCellViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

/// A generic cell view model for linking enumerated setings values to button cells
class SettingsButtonCellViewModel<T: RawRepresentable> where T.RawValue == String {
	
	// Stored enum
	let value: T
	
	// Observables for setting's state, when the setting is updated they notify the cell to change its button state in response
	private var _isSelected = CoalescingObservable<Bool>(false)
	private var _isAvailable = CoalescingObservable<Bool>(true)
	
	//MARK: Properties
	var selectionHandler: (() -> Void)?
	
	// Whether or not a setting is selected
	var isSelected: Bool {
		get {
			return _isSelected.value
		}
		set {
			_isSelected.value = newValue
		}
	}
	
	// Whether or not a setting is available
	var isAvailable: Bool {
		get {
			return _isAvailable.value
		}
		set {
			_isAvailable.value = newValue
		}
	}
	
	init(value: T) {
		self.value = value
	}
}

extension SettingsButtonCellViewModel: ItemRepresentable {
	static func registerCell(collectionView: UICollectionView) {
		collectionView.register(
			ButtonCell.self,
			forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)
	}
	
	func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: ButtonCell.reuseIdentifier,
			for: indexPath)
		
		if let buttonCell = cell as? ButtonCell {
			
			// Set button title label to the string representable setting's raw value
			buttonCell.title = value.rawValue
			
			// On button press handle setting selection
			buttonCell.didPressHandler = { [weak self] in
				self?.handleSelection()
			}
			
			// When the settings selection state changes, update the cell's button state
			buttonCell.observe(_isSelected, options: [.initial]) { [weak buttonCell, weak self] (isSelected, _) in
				if isSelected {
					// Set an selected setting's button to the selected state
					buttonCell?.state = .selected
				} else {
					// Set unselected setting's button to the normal or disabled based on the availability state
					buttonCell?.state = self?.isAvailable == true ? .normal : .disabled
				}
			}
			
			// When the settings availability state changes, update the cell's button state
			buttonCell.observe(_isAvailable, options: [.initial]) { [weak buttonCell, weak self] (isAvailable, _) in
				if isAvailable {
					// if a setting is availaible set the cell's button to selected or not depending on it's selected state
					buttonCell?.state = self?.isSelected == true ? .selected : .normal
				} else {
					// if a setting is unavailable set the cell's button to disabled
					buttonCell?.state = .disabled
				}
			}
		}
		
		return cell
	}
}

extension SettingsButtonCellViewModel: Selectable {
	func handleSelection() {
		selectionHandler?()
	}
}
