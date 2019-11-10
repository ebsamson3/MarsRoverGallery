//
//  SelectorCellViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class SelectorCellViewModel<T: RawRepresentable> where T.RawValue == String {
	var value: T
	private var _isActive = Observable<Bool>(false)
	private var _isAvailable = Observable<Bool>(true)
	var selectionHandler: (() -> Void)?
	
	var isActive: Bool {
		get {
			return _isActive.value
		}
		set {
			_isActive.value = newValue
		}
	}
	
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

extension SelectorCellViewModel: ItemRepresentable {
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
			
			selectorCell.title = value.rawValue
			
			selectorCell.selectionHandler = { [weak self] in
				self?.handleSelection()
			}
			
			selectorCell.observe(_isActive, options: [.initial]) { [weak selectorCell] (isActive, _) in
				selectorCell?.state = isActive ? .selected : .normal
			}
			
			selectorCell.observe(_isAvailable, options: [.initial]) { [weak selectorCell, weak self] (isAvailable, _) in
				if isAvailable {
					selectorCell?.state = self?.isActive == true ? .selected : .normal
				} else {
					selectorCell?.state = .disabled
				}
			}
		}
		
		return cell
	}
}

extension SelectorCellViewModel: Selectable {
	func handleSelection() {
		selectionHandler?()
	}
}
