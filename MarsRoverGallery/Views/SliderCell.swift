//
//  SliderCell.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class SliderCell: UICollectionViewCell {
	
	static let reuseIdentifier = "SliderCell"
	
	let titleLabel: UILabel = {
		let titleLabel = UILabel()
		titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
		titleLabel.text = "Title"
		titleLabel.textColor = .yellow
		return titleLabel
	}()
	
	let valueLabel: UILabel = {
		let valueLabel = UILabel()
		valueLabel.text = "Value"
		valueLabel.textColor = .yellow
		return valueLabel
	}()
	
	lazy var slider: UISlider = {
		let slider = UISlider()
		slider.tintColor = .yellow
		
		slider.addTarget(
			self,
			action: #selector(sliderValueDidChange(sender:)),
			for: .valueChanged)
		
		return slider
	}()
	
	var currentValue: Float = 0
	var minimumValue: Float = 0
	var maximumValue: Float = 100
	var isDisabled = false
	var handleSliderValueDidChange: ((Float) -> Void)?
    
	@objc func sliderValueDidChange(sender: UISlider) {
		handleSliderValueDidChange?(sender.value)
		configure()
	}
//
//	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//		super.init(style: style, reuseIdentifier: reuseIdentifier)
//		configure()
//	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure() {
		contentView.addSubview(titleLabel)
		contentView.addSubview(valueLabel)
		contentView.addSubview(slider)
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		valueLabel.translatesAutoresizingMaskIntoConstraints = false
		slider.translatesAutoresizingMaskIntoConstraints = false
		
		let margins = contentView.layoutMarginsGuide
		
		titleLabel.topAnchor.constraint(
			equalTo: margins.topAnchor)
			.isActive = true
		titleLabel.leadingAnchor.constraint(
			equalTo: margins.leadingAnchor)
			.isActive = true
		titleLabel.trailingAnchor.constraint(
			equalTo: margins.trailingAnchor)
			.withPriority(.defaultHigh)
			.isActive = true
		
		valueLabel.topAnchor.constraint(
			equalTo: titleLabel.bottomAnchor,
			constant: Constants.Spacing.large)
			.isActive = true
		valueLabel.leadingAnchor.constraint(
			equalTo: margins.leadingAnchor)
			.isActive = true
		valueLabel.trailingAnchor.constraint(
			equalTo: margins.trailingAnchor)
			.withPriority(.defaultHigh)
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
