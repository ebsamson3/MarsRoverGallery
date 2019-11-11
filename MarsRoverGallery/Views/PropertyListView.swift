//
//  PropertyListView.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/8/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

/// View for a of colon-separated property-value labels
class PropertyListView: UIView {
	typealias Property = (name: String, value: String)
	typealias PropertyLabelPair = (nameLabel: UILabel, valueLabel: UILabel)
	
	// If properties are set, reconfigure the subviews
	var properties: [(name: String, value: String)] {
		didSet {
			configure()
			setNeedsLayout()
		}
	}
	
	// Stoes labels for each property-value pair
	private var propertyLabelPairs = [PropertyLabelPair]()
	
	init(_ properties: [Property] = [])  {
		self.properties = properties
		super.init(frame: CGRect.zero)
		configure()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure() {
		propertyLabelPairs = generateLabelPairs()
		layoutLabelPairs()
	}
	
	/// Generates label pairs for each property
	private func generateLabelPairs() -> [PropertyLabelPair] {
		
		// Clean up old label pairs
		for labelPair in propertyLabelPairs {
			labelPair.nameLabel.removeFromSuperview()
			labelPair.valueLabel.removeFromSuperview()
		}
		
		propertyLabelPairs = []
		
		// Create new label pairs for each property
		return properties.map { property in
			
			let nameLabel = UILabel.clearCaption()
			nameLabel.text = "\(property.name):"
						
			let valueLabel = UILabel.clearCaption()
			valueLabel.numberOfLines = 0
			valueLabel.lineBreakMode = .byWordWrapping
			valueLabel.text = property.value
			
			return (nameLabel: nameLabel, valueLabel: valueLabel)
		}
	}
	
	/// Layout label pairs
	private func layoutLabelPairs() {

		guard !propertyLabelPairs.isEmpty else {
			return
		}

		let numberOfLabelPairs = propertyLabelPairs.count
		let firstLabelPair = propertyLabelPairs[0]

		propertyLabelPairs.enumerated().forEach { (index, labelPair) in

			let nameLabel = labelPair.nameLabel
			let valueLabel = labelPair.valueLabel

			addSubview(nameLabel)
			addSubview(valueLabel)

			nameLabel.translatesAutoresizingMaskIntoConstraints = false
			valueLabel.translatesAutoresizingMaskIntoConstraints = false

			let nameLabelTrailingAnchor = (index == 0) ?
				valueLabel.leadingAnchor :
				firstLabelPair.nameLabel.trailingAnchor

			let nameLabelTrailingAnchorSpacing: CGFloat = (index == 0) ?
				-Constants.Spacing.small : 0

			nameLabel.topAnchor.constraint(
				equalTo: valueLabel.topAnchor)
				.isActive = true
			nameLabel.trailingAnchor.constraint(
				equalTo: nameLabelTrailingAnchor,
				constant: nameLabelTrailingAnchorSpacing)
				.isActive = true
			nameLabel.leadingAnchor.constraint(
				equalTo: leadingAnchor)
				.isActive = true

			if index > 0 {
				let previousNameLabel = propertyLabelPairs[index - 1].nameLabel

				nameLabel.topAnchor.constraint(
					greaterThanOrEqualTo: previousNameLabel.bottomAnchor,
					constant: Constants.Spacing.small)
					.isActive = true
			}

			let valueLabelTopAnchor = (index > 0) ?
				propertyLabelPairs[index - 1].valueLabel.bottomAnchor :
				topAnchor

			let valueLabelTopAnchorSpacing = index > 0 ?
				Constants.Spacing.small : 0

			valueLabel.topAnchor.constraint(
				greaterThanOrEqualTo: valueLabelTopAnchor,
				constant: valueLabelTopAnchorSpacing)
				.isActive = true

			valueLabel.trailingAnchor.constraint(
				equalTo: trailingAnchor)
				.isActive = true

			if index > 0 {
				let previousValueLabel = propertyLabelPairs[index - 1].valueLabel

				valueLabel.leadingAnchor.constraint(
					equalTo: previousValueLabel.leadingAnchor)
					.isActive = true
			}

			// Configure constriants such that when the label pair gets compressed, the value label beings word wrapping
			nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
			nameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
			valueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
			valueLabel.setContentCompressionResistancePriority(.init(999), for: .horizontal)

			if index == numberOfLabelPairs - 1 {
				nameLabel.bottomAnchor.constraint(
					lessThanOrEqualTo: bottomAnchor)
					.isActive = true
				valueLabel.bottomAnchor.constraint(
					lessThanOrEqualTo: bottomAnchor)
					.isActive = true
			}
		}
	}
}
