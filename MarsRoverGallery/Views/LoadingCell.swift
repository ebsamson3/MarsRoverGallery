//
//  LoadingCell.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/8/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

/// Clear cell with an activity indicator at it's center
class LoadingCell: UICollectionViewCell {
	
	static let reuseIdentifier = "LoadingCell"
    
	let spinner: UIActivityIndicatorView = {
		let spinner = UIActivityIndicatorView()
		spinner.style = .large
		spinner.color = .white
		return spinner
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		spinner.stopAnimating()
	}
	
	private func configure() {
		contentView.addSubview(spinner)
		spinner.translatesAutoresizingMaskIntoConstraints = false
		spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
		spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
	}
}
