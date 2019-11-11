//
//  UILabel+Extensions.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/8/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

extension UILabel {
	
	static func clearCaption() -> UILabel {
		let label = UILabel()
		label.backgroundColor = .clear
		label.isOpaque = false
		label.font = UIFont.boldSystemFont(ofSize: 16)
		label.textColor = .brightText
		return label
	}
}
