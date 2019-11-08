//
//  LoadingCellViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/8/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class LoadingCellViewModel {
	
}

extension LoadingCellViewModel: ItemRepresentable {
	static func registerCell(collectionView: UICollectionView) {
		collectionView.register(
			LoadingCell.self,
			forCellWithReuseIdentifier: LoadingCell.reuseIdentifier)
	}
	
	func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: LoadingCell.reuseIdentifier,
			for: indexPath)
		
		if let loadingCell = cell as? LoadingCell {
			loadingCell.spinner.startAnimating()
		}
		
		return cell
	}
}
