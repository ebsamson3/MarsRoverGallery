//
//  CollectionHeaderRepresentable.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

protocol CollectionHeaderRepresentable {
	static func registerHeader(collectionView: UICollectionView)
	func headerInstance(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView
}
