//
//  SliderCellViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class SliderCellViewModel {
	
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
		
		return cell
	}
	
	
}
