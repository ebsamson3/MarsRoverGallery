//
//  NameValuePairCellViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 8/6/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit
//
//class NameValuePairCellViewModel {
//	
//	var name: String?
//	var value: String?
//	var isMultiLine = false
//	
//	var selectionHandler: (() -> Void)?
//	
//	init(name: String, value: String?) {
//			self.name = name
//			self.value = value
//	}
//	
//}
//
//extension NameValuePairCellViewModel: CellRepresentable {
//	
//	static func registerCell(tableView: UITableView) {
//		tableView.register(
//			NameValuePairCell.self,
//			forCellReuseIdentifier: NameValuePairCell.reuseIdentifier)
//	}
//	
//	func cellInstance(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
//		let cell = tableView.dequeueReusableCell(withIdentifier: NameValuePairCell.reuseIdentifier, for: indexPath)
//		
//		if let nameValuePairCell = cell as? NameValuePairCell {
//			
//			nameValuePairCell.name = name
//			nameValuePairCell.value = value
//			nameValuePairCell.isMultiLine = isMultiLine
//		}
//		
//		return cell
//	}
//}
