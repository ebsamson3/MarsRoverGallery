//
//  NSLayoutConstraint+Extensions.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/8/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
	func withPriority(_ priority: UILayoutPriority ) -> NSLayoutConstraint {
		self.priority = priority
		return self
	}
}
