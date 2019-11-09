//
//  SettingsSectionHeaderViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class SettingsSectionHeaderViewModel {
	
	var title: String?
	
	init(title: String) {
		self.title = title
	}
	
}

extension SettingsSectionHeaderViewModel: CollectionHeaderRepresentable {
	static func registerHeader(collectionView: UICollectionView) {
		collectionView.register(
			SettingsSectionHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: SettingsSectionHeaderView.reuseIdentifier)
	}
	
	func headerInstance(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryView(
			ofKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: SettingsSectionHeaderView.reuseIdentifier,
			for: indexPath)
		
		if let settingsSectionHeader = header as? SettingsSectionHeaderView {
			settingsSectionHeader.title = title
		}
		
		return header
	}
}
