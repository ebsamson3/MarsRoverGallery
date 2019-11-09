//
//  SelectorCellViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class SelectorCellViewModel {
	var title: String?
	
	init(title: String?) {
		self.title = title
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
			selectorCell.title = title
		}
		
		return cell
	}
}
