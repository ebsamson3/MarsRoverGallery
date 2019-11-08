//
//  CollectionViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/6/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

protocol CollectionViewModel: class {
	var numberOfSections: Int { get }
	var reloadData: (() -> Void)? { get set }
	var insertItems: (([IndexPath]) -> Void)? { get set }
	var deleteItems: (([IndexPath]) -> Void)? { get set }
	
	func registerCells(collectionView: UICollectionView)
	func numberOfItems(inSection section: Int) -> Int
	func viewModelForItem(at indexPath: IndexPath) -> ItemRepresentable
	func sizeForItem(at indexPath: IndexPath) -> CGSize
	func didSelectItem(at indexPath: IndexPath)
	func prefetchItems(at indexPaths: [IndexPath])
	func cancelPrefetchingForItems(at indexPaths: [IndexPath])
	func scrollViewDidScroll(_ scrollView: UIScrollView)
}

extension CollectionViewModel {
	var numberOfSections: Int {
		return 1
	}
	
	var reloadData: (() -> Void)? {
		get {
			return nil
		}
		set {
			return
		}
	}
	
	var insertItems: (([IndexPath]) -> Void)? {
		get {
			return nil
		}
		set {
			return
		}
	}
	
	var deleteItems: (([IndexPath]) -> Void)? {
		get {
			return nil
		}
		set {
			return
		}
	}
}
