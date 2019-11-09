//
//  TableViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/8/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

protocol TableViewModel: class {
	
	var numberOfSections: Int { get}
	var hasDivider: Bool { get }
	var reloadData: (() -> Void)? { get set }
	var insertCells: (([IndexPath]) -> Void)? { get set }
	var deleteCells: (([IndexPath]) -> Void)? { get set }
	
	func registerCells(tableView: UITableView)
	func title(forSection section: Int) -> String?
	func numberOfRows(inSection section: Int) -> Int
	func getCellViewModel(at indexPath: IndexPath) -> CellRepresentable?
	func didSelectRow(at indexPath: IndexPath)
	func shouldHighlightRow(at indexPath: IndexPath) -> Bool
}

extension TableViewModel {
	var numberOfSections: Int {
		return 1
	}
	
	var hasDivider: Bool {
		return true
	}
	
	var reloadData: (() -> Void)? {
		get {
			return nil
		}
		set {
			return
		}
	}
	
	var insertCells: (([IndexPath]) -> Void)? {
		get {
			return nil
		}
		set {
			return
		}
	}
	
	var deleteCells: (([IndexPath]) -> Void)? {
		get {
			return nil
		}
		set {
			return
		}
	}
	
	func title(forSection section: Int) -> String? {
		return nil
	}
	
	func didSelectRow(at indexPath: IndexPath) {}
	
	func shouldHighlightRow(at indexPath: IndexPath) -> Bool {
		return false
	}
}

