//
//  RoverSettingCellViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class RoverSettingCellViewModel {
	
	let roverName: Rover.Name
	private var _isActive = Observable<Bool>(false)
	var selectionHandler: (() -> Void)?
	
	var isActive: Bool {
		get {
			return _isActive.value
		}
		set {
			_isActive.value = newValue
		}
	}
	
	init(roverName: Rover.Name) {
		self.roverName = roverName
	}
}

extension RoverSettingCellViewModel: ItemRepresentable {
	static func registerCell(collectionView: UICollectionView) {
		collectionView.register(
			SelectorCell.self,
			forCellWithReuseIdentifier: SelectorCell.reuseIdentifier)
	}
	
	func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: SelectorCell.reuseIdentifier,
			for: indexPath)
		
		if let selectorCell = cell as? SelectorCell {
			selectorCell.title = roverName.rawValue
			selectorCell.observe(_isActive, options: [.initial]) { [weak selectorCell] (isActive, _) in
				selectorCell?.state = isActive ? .selected : .normal
			}
			selectorCell.selectionHandler = { [weak self] in
				self?.handleSelection()
			}
		}
		
		return cell
	}
}

extension RoverSettingCellViewModel: Selectable {
	func handleSelection() {
		selectionHandler?()
	}
}
