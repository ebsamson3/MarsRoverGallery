//
//  SettingsFooterView.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class SettingsFooterView: UIView {

	let cancelButton: SettingsButton = {
		let button = SettingsButton(color: UIColor.yellow)
		button.setTitle("Cancel", for: .normal)
		return button
	}()
	
	let submitButton: SettingsButton  = {
		   let button = SettingsButton(color: UIColor.yellow)
		   button.setTitle("Submit", for: .normal)
		   return button
	   }()
	
	init() {
		super.init(frame: CGRect.zero)
		configure()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure() {
		backgroundColor = .background
		
		addSubview(cancelButton)
		addSubview(submitButton)
		
		cancelButton.translatesAutoresizingMaskIntoConstraints = false
		submitButton.translatesAutoresizingMaskIntoConstraints = false
		
		cancelButton.setContentHuggingPriority(.required, for: .vertical)
		submitButton.setContentHuggingPriority(.required, for: .vertical)
		setContentHuggingPriority(.required, for: .vertical)
		
		let margins = layoutMarginsGuide
		
		cancelButton.topAnchor.constraint(
			equalTo: topAnchor,
			constant: Constants.Spacing.large)
			.isActive = true
		
		cancelButton.trailingAnchor.constraint(
			equalTo: centerXAnchor,
			constant: -Constants.Spacing.small)
			.isActive = true
		
		cancelButton.bottomAnchor.constraint(
			equalTo: margins.bottomAnchor,
			constant: -Constants.Spacing.large)
			.isActive = true

		cancelButton.leadingAnchor.constraint(
			equalTo: leadingAnchor,
			constant: Constants.Spacing.large)
			.isActive = true
		
		submitButton.topAnchor.constraint(
			equalTo: topAnchor,
			constant: Constants.Spacing.large)
			.isActive = true
		
		submitButton.leadingAnchor.constraint(
			equalTo: centerXAnchor,
			constant: Constants.Spacing.small)
			.isActive = true
		
		submitButton.bottomAnchor.constraint(
			equalTo: margins.bottomAnchor,
			constant: -Constants.Spacing.large)
			.isActive = true
		
		submitButton.trailingAnchor.constraint(
			equalTo: trailingAnchor,
			constant: -Constants.Spacing.large)
			.isActive = true
	}
}
