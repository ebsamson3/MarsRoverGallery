//
//  CollectionViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/6/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

/// Standard collection view model protocol
protocol CollectionViewModel: class {
	var numberOfSections: Int { get }
	var reloadData: (() -> Void)? { get set }
	var reloadSections: ((IndexSet) -> Void)? { get set }
	var insertItems: (([IndexPath]) -> Void)? { get set }
	var deleteItems: (([IndexPath]) -> Void)? { get set }
	var performBatchUpdates: ((()-> Void) -> Void)? { get set }
	
	func registerCells(collectionView: UICollectionView)
	func registerHeaders(collectionView: UICollectionView)
	func numberOfItems(inSection section: Int) -> Int
	func viewModelForItem(at indexPath: IndexPath) -> ItemRepresentable
	func viewModelForHeader(at indexPath: IndexPath) -> CollectionHeaderRepresentable?
	func sizeForItem(at indexPath: IndexPath) -> CGSize
	func insets(forSection section: Int) -> UIEdgeInsets 
	func didSelectItem(at indexPath: IndexPath)
	func prefetchItems(at indexPaths: [IndexPath])
	func cancelPrefetchingForItems(at indexPaths: [IndexPath])
	func scrollViewDidScroll(_ scrollView: UIScrollView)
}

// Default implementation to reduce required boilerplate for collection view models
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
	
	var reloadSections: ((IndexSet) -> Void)? {
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
	
	var performBatchUpdates: ((()-> Void) -> Void)? {
		get {
			return nil
		}
		set {
			return
		}
	}
	
	func registerHeaders(collectionView: UICollectionView) {}
	
	func prefetchItems(at indexPaths: [IndexPath]) {}
	
	func cancelPrefetchingForItems(at indexPaths: [IndexPath]) {}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {}
	
	func insets(forSection section: Int) -> UIEdgeInsets {
		return UIEdgeInsets.zero
	}
	
	func viewModelForHeader(at indexPath: IndexPath) -> CollectionHeaderRepresentable? {
		return nil
	}
}
