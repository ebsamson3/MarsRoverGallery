//
//  SettingsFooterView.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

protocol SettingsFooterViewDelegate: class {
	func settingsFooterDidCancel()
	func settingsFooterDidSubmit()
}

/// Footer view that contains a cancellated and submission buttons + a delegate protocol to handle the button presses
class SettingsFooterView: UIView {

	// MARK: Views
	private let cancelButton: SettingsButton = {
		let button = SettingsButton(color: UIColor.yellow)
		button.setTitle("Cancel", for: .normal)
		
		button.addTarget(
			self,
			action: #selector(didPressButton(_:)),
			for: .touchUpInside)
		
		return button
	}()
	
	private let submitButton: SettingsButton  = {
		let button = SettingsButton(color: UIColor.yellow)
		button.setTitle("Submit", for: .normal)
		
		button.addTarget(
			self,
			action: #selector(didPressButton(_:)),
			for: .touchUpInside)
		   return button
	}()
	
	//MARK: Properties
	weak var delegate: SettingsFooterViewDelegate?
	
	//MARK: Lifecycle
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
	
	/// Handles the button press and notifies the delegate based on which button was pressed
	@objc private func didPressButton(_ sender: SettingsButton) {
		if sender == cancelButton {
			delegate?.settingsFooterDidCancel()
		} else if sender == submitButton {
			delegate?.settingsFooterDidSubmit()
		}
	}
	
	//MARK: Configure Layout
	
	private func configure() {
		backgroundColor = .background
		
		addSubview(cancelButton)
		addSubview(submitButton)
		
		cancelButton.translatesAutoresizingMaskIntoConstraints = false
		submitButton.translatesAutoresizingMaskIntoConstraints = false
		
		// Set content hugging priority to required for vertical so that the footer view does not expand to hide a collection view with no content compression resisitance. 
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
