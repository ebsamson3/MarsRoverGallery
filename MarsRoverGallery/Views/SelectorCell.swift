//
//  SelectorCell.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class SelectorCell: UICollectionViewCell {
	static let reuseIdentifier = "SelectorCell"
	
	let button = SettingsButton(color: UIColor.yellow)
	
	var title: String? = nil {
		didSet {
			button.setTitle(title, for: .normal)
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
	
	private func configure() {
		contentView.addSubview(button)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
		button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
	}
}
