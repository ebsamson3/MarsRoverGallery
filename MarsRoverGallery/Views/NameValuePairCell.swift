//
//  NameValuePairCell.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 8/6/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class NameValuePairCell: UITableViewCell {

    static var reuseIdentifier = "NameValuePairCell"
	
	private let nameLabel = UILabel.standard().embolden()
	
	private let valueLabel: UILabel = {
		let label = UILabel.standard()
		label.textAlignment = .right
		label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
		return label
	}()
	
	var name: String? {
		didSet {
			nameLabel.text = nameLabelString
		}
	}
	
	private var nameLabelString: String {
		let baseString = name ?? ""
		return baseString + ":"
	}
	
	var value: String? {
		didSet {
			valueLabel.text = value
		}
	}
	
	var isMultiLine = false {
		didSet {
			if isMultiLine {
				valueLabel.numberOfLines = 0
				valueLabel.lineBreakMode = .byWordWrapping
			} else {
				valueLabel.numberOfLines = 1
			}
		}
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configure()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure() {
		contentView.addSubview(nameLabel)
		contentView.addSubview(valueLabel)
		
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		valueLabel.translatesAutoresizingMaskIntoConstraints = false
		
		let margins = contentView.layoutMarginsGuide
		
		nameLabel.topAnchor.constraint(
			equalTo: contentView.topAnchor,
			constant: Constants.Spacing.large)
			.isActive = true
		
		nameLabel.trailingAnchor.constraint(
			lessThanOrEqualTo: valueLabel.leadingAnchor,
			constant: -Constants.Spacing.large)
			.isActive = true
		
		nameLabel.bottomAnchor.constraint(
			equalTo: contentView.bottomAnchor,
			constant: -Constants.Spacing.large)
			.withPriority(.defaultHigh)
			.isActive = true
		
		nameLabel.leadingAnchor.constraint(
			equalTo: margins.leadingAnchor)
			.isActive = true
		
		valueLabel.topAnchor.constraint(
			equalTo: contentView.topAnchor,
			constant: Constants.Spacing.large)
			.isActive = true
		
		valueLabel.trailingAnchor.constraint(
			equalTo: margins.trailingAnchor)
			.withPriority(.defaultHigh)
			.isActive = true
		
		valueLabel.bottomAnchor.constraint(
			equalTo: contentView.bottomAnchor,
			constant: -Constants.Spacing.large)
			.withPriority(.defaultHigh)
			.isActive = true
	}
}
