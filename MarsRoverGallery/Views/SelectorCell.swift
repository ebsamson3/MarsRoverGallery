//
//  SelectorCell.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class SelectorCell: UICollectionViewCell, Observer {
	
	static let reuseIdentifier = "SelectorCell"
	
	var disposeBag = DisposeBag()
	
	private lazy var button: SettingsButton = {
		let button = SettingsButton(color: UIColor.yellow)
		
		button.addTarget(
			self,
			action: #selector(handleButtonSelection(_:)),
			for: .touchUpInside)
		
		return button
	}()
	
	var title: String? = nil {
		didSet {
			button.setTitle(title, for: .normal)
		}
	}
	
	var selectionHandler: (() -> Void)?
	
	var state = UIControl.State.normal {
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
			default:
				break
			}
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = layer.bounds.height * 0.25
	}
	
	override func prepareForReuse() {
		disposeBag = DisposeBag()
	}
	
	private func configure() {
		contentView.addSubview(button)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
		button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
	}
	
	@objc private func handleButtonSelection(_ sender: UIButton) {
		selectionHandler?()
	}
}
