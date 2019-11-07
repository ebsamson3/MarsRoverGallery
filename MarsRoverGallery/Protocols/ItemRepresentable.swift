//
//  ItemRepresentable.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/6/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

protocol ItemRepresentable {
	static func registerCell(collectionView: UICollectionView)
	func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}
