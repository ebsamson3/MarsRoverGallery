//
//  SliderCell.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class SliderCell: UICollectionViewCell, Observer {
	
	var disposeBag = DisposeBag()
	
	static let reuseIdentifier = "SliderCell"
	
	let valueLabel: UILabel = {
		let label = UILabel()
		label.text = "Value"
		label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
		label.font = UIFont.boldSystemFont(ofSize: 20)
		label.textColor = .brightText
		return label
	}()
	
	private lazy var slider: UISlider = {
		let slider = UISlider()
		slider.tintColor = .yellow
		
		slider.addTarget(
			self,
			action: #selector(sliderValueDidChange(sender:)),
			for: .valueChanged)
		
		return slider
	}()
	
	var valueString: String? = nil {
		didSet {
			valueLabel.text = valueString
		}
	}
	
	var currentValue: Float = 0 {
		didSet {
			slider.value = currentValue
		}
	}
	
	var minimumValue: Float = 0 {
		didSet {
			slider.minimumValue = minimumValue
		}
	}

	var maximumValue: Float = 1 {
		didSet {
			slider.maximumValue = maximumValue
		}
	}
	var isLoading = false {
		didSet {
			slider.isEnabled = !isLoading
		}
	}
	
	var handleSliderValueDidChange: ((Float) -> Void)?
    
	@objc func sliderValueDidChange(sender: UISlider) {
		handleSliderValueDidChange?(sender.value)
		configure()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		disposeBag = DisposeBag()
	}
	
	private func configure() {
		contentView.addSubview(valueLabel)
		contentView.addSubview(slider)
		
		valueLabel.translatesAutoresizingMaskIntoConstraints = false
		slider.translatesAutoresizingMaskIntoConstraints = false
		
		let margins = contentView.layoutMarginsGuide
		
		valueLabel.topAnchor.constraint(
			equalTo: contentView.topAnchor,
			constant: Constants.Spacing.large)
			.isActive = true
		valueLabel.leadingAnchor.constraint(
			greaterThanOrEqualTo: margins.leadingAnchor)
			.isActive = true
		valueLabel.trailingAnchor.constraint(
			lessThanOrEqualTo: margins.trailingAnchor)
			.withPriority(.defaultHigh)
			.isActive = true
		valueLabel.centerXAnchor.constraint(
			equalTo: contentView.centerXAnchor)
			.isActive = true
		
		slider.topAnchor.constraint(
			greaterThanOrEqualTo: valueLabel.bottomAnchor,
			constant: Constants.Spacing.large)
			.isActive = true
		slider.leadingAnchor.constraint(
			equalTo: margins.leadingAnchor)
			.isActive = true
		slider.trailingAnchor.constraint(
			equalTo: margins.trailingAnchor)
			.withPriority(.defaultHigh)
			.isActive = true
		slider.bottomAnchor.constraint(
			equalTo: margins.bottomAnchor)
			.withPriority(.defaultHigh)
			.isActive = true
	}
}
