//
//  LabelCellViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

/// View model that registers and instantiates a label collectinoViewCell
class LabelCellViewModel {
	
	var title: String?
	
	init(title: String? = nil) {
		self.title = title
	}
}

extension LabelCellViewModel: ItemRepresentable {
	static func registerCell(collectionView: UICollectionView) {
		collectionView.register(
			LabelCell.self,
			forCellWithReuseIdentifier: LabelCell.reuseIdentifier)
	}
	
	func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: LabelCell.reuseIdentifier,
			for: indexPath)
		
		if let labelCell = cell as? LabelCell {
			labelCell.title = title
		}
		
		return cell
	}
}
