//
//  SettingsSectionHeaderView.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class SettingsSectionHeaderView: UICollectionReusableView {
	
	static let reuseIdentifier = "SettingsSectionHeader"
        
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 20)
		label.textColor = .magenta
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
		addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		
		titleLabel.centerXAnchor.constraint(
			equalTo: centerXAnchor)
			.isActive = true
		titleLabel.centerYAnchor.constraint(
			equalTo: centerYAnchor)
			.isActive = true
	}
}
