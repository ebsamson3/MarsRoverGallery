//
//  SettingsButton.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

/// A button used for selecting settings in the Search Settings Collection View
class SettingsButton: UIButton {
	
	// When the button is highlighted, invert it's colors such that the text color becomes the background color
	override var isHighlighted: Bool {
		didSet {
			backgroundColor = isHighlighted || isSelected ? color : .clear
		}
	}
	
	// When a cell is selected, invert it's colors such that the text color becomes the background color
	override var isSelected: Bool {
		didSet {
			backgroundColor = isSelected || isHighlighted ? color : .clear
		}
	}
	
	// When a button is disabled, set it's color to gray
	override var isEnabled: Bool {
		didSet {
			if isEnabled {
				setColor(to: color)
				backgroundColor = isSelected ? color : .clear
			} else {
				setColor(to: .lightGray)
				backgroundColor = .clear
			}
		}
	}
	
	//MARK: Properties
	var cornerRadiusToHeightRatio: CGFloat = 0.3
	
	// Sets the main color of the buttons text and border. Also background when the button is in the selected state
	var color: UIColor = .brightText {
		didSet {
			setColor(to: color)
		}
	}
    
	//MARK: Lifecycle
	
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
	
	//MARK: Configure Layout
    
    private func setup() {
		setColor(to: color)
        setTitleColor(UIColor.darkText, for: .highlighted)
		setTitleColor(UIColor.darkText, for: .selected)
		
        titleLabel?.textAlignment = .center
        titleLabel?.baselineAdjustment = .alignCenters
		titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		layer.borderWidth = 1
    }

	private func setColor(to color: UIColor) {
		setTitleColor(color, for: .normal)
		layer.borderColor = color.cgColor
	}
}
