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
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 20)
		label.textColor = .yellow
		return label
	}()
	
	var title: String? = nil {
		didSet {
			titleLabel.text = title
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
		layer.masksToBounds = true
		layer.borderColor = UIColor.yellow.cgColor
		layer.borderWidth = 1.0
		contentView.addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		
		titleLabel.centerXAnchor.constraint(
			equalTo: contentView.centerXAnchor)
			.isActive = true
		
		titleLabel.centerYAnchor.constraint(
			equalTo: contentView.centerYAnchor)
			.isActive = true
	}
}
