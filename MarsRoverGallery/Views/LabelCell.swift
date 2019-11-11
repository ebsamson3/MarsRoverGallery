//
//  LabelCell.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

/// Basic collection view cell with a centered label
class LabelCell: UICollectionViewCell {
	static let reuseIdentifier = "LabelCell"
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
		label.font = UIFont.boldSystemFont(ofSize: 20)
		label.textColor = .brightText
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
	
	private func configure() {
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
