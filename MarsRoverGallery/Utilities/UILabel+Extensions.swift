//
//  UILabel+Extensions.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/8/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

extension UILabel {
	
	static func fontSize() -> CGFloat {
		let deviceIdiom = UIDevice.current.userInterfaceIdiom
		
		if deviceIdiom == .pad {
			return 32
		} else {
			return UIFont.labelFontSize
		}
	}
	
	static func standard() -> UILabel {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .body)
			.withSize(UILabel.fontSize())
		label.baselineAdjustment = .alignCenters
		label.textColor = .darkText
		label.isOpaque = true
		return label
	}
	
	func embolden() -> Self {
		self.font = UIFont.boldSystemFont(ofSize: UILabel.fontSize())
		return self
	}
}
