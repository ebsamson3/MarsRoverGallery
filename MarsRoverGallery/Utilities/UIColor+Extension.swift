//
//  UIColor+Extension.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/7/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return .init(
			hue: .random(in: 0...1),
			saturation: 1,
			brightness: 1,
			alpha: 1)
    }
	
	static var background = UIColor.black
}

