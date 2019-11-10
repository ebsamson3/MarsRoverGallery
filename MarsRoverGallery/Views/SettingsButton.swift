//
//  SettingsButton.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class SettingsButton: UIButton {
	
	var cornerRadiusToHeightRatio: CGFloat = 0.3
	
	var color: UIColor = .brightText {
		didSet {
			setColor()
		}
	}
	
	var isActive = false {
		didSet {
			backgroundColor = isActive ? color : .clear
		}
	}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
	
	init(color: UIColor) {
        super.init(frame: CGRect.zero)
		self.color = color
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height * cornerRadiusToHeightRatio
		
    }
	
	override var isHighlighted: Bool {
		didSet {
			backgroundColor = isHighlighted ? color : .clear
		}
	}
    
    private func setup() {
		setColor()
        setTitleColor(UIColor.darkText, for: .highlighted)
        titleLabel?.textAlignment = .center
        titleLabel?.baselineAdjustment = .alignCenters
		titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
		layer.borderWidth = 1
    }

	private func setColor() {
		setTitleColor(color, for: .normal)
		layer.borderColor = color.cgColor
		
		if isActive {
			backgroundColor = color
		}
	}
}
