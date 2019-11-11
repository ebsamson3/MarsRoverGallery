//
//  ButtonCell.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

/// Simple cell with a bordered button.
class ButtonCell: UICollectionViewCell, Observer {
	
	/// Possible cell states
	enum State {
		case selected
		case normal
		case disabled
	}
	
	static let reuseIdentifier = "SelectorCell"
	
	// Dispose bag for cleaning up bound observable values on de-init or reuse
	var disposeBag = DisposeBag()
	
	// MARK: Views
	private lazy var button: SettingsButton = {
		let button = SettingsButton(color: UIColor.yellow)
		
		button.addTarget(
			self,
			action: #selector(handleButtonPress(_:)),
			for: .touchUpInside)
		
		return button
	}()
	
	// MARK: Properties
	
	var title: String? = nil {
		didSet {
			button.setTitle(title, for: .normal)
		}
	}
	
	var didPressHandler: (() -> Void)?
	
	var state = State.normal {
		didSet {
			switch state {
			case .normal:
				button.isEnabled = true
				button.isSelected = false
			case .selected:
				button.isEnabled = true
				button.isSelected = true
			case .disabled:
				button.isEnabled = false
				button.isSelected = false
			}
		}
	}
	
	//MARK: Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// Set the corner radius on layout
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = layer.bounds.height * 0.25
	}
	
	// On reuse discard any bindings to observable objects
	override func prepareForReuse() {
		disposeBag = DisposeBag()
	}
	
	// MARK: Configure Layout
	
	private func configure() {
		contentView.addSubview(button)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
		button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
	}
	
	/// Handles button press
	@objc private func handleButtonPress(_ sender: UIButton) {
		didPressHandler?()
	}
}
