//
//  ImageCell.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/7/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
	
	static let reuseIdentifier = "PhotoCell"
	var representedId: ObjectIdentifier?
	
	private let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.backgroundColor = .random
		return imageView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = layer.bounds.width * 0.05
	}
	
	override func prepareForReuse() {
		representedId = nil
	}
	
	private func configure() {
		
		layer.masksToBounds = true
		
		contentView.addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		imageView.topAnchor.constraint(
			equalTo: contentView.topAnchor)
			.isActive = true
		imageView.trailingAnchor.constraint(
			equalTo: contentView.trailingAnchor)
			.isActive = true
		imageView.bottomAnchor.constraint(
			equalTo: contentView.bottomAnchor)
			.isActive = true
		imageView.leadingAnchor.constraint(
			equalTo: contentView.leadingAnchor)
			.isActive = true
	}
	
	func setImage(to image: UIImage?) {
		imageView.image = image
	}
}
