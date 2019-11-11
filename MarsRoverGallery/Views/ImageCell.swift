//
//  ImageCell.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/7/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

//Collection vie wcell that displays an image
class ImageCell: UICollectionViewCell {
	
	static let reuseIdentifier = "PhotoCell"
	
	// Used to identify the view model by object identifier, this way if the view model changes we won't try to update the image with an old view model's image
	var representedId: ObjectIdentifier?
	
	//MARK: Views
	
	private let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.backgroundColor = .lightGray
		return imageView
	}()
	
	//MARK: Lifecycle
	
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
	
	//MARK: Configure layout
	
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
	
	//MARK: Methods
	///Sets the image view image, if anmated the transition will use a cross-dissolve animation
	func setImage(to image: UIImage?, animated: Bool = false) {
		if animated {
			UIView.transition(
				with: imageView,
				duration: 0.5,
				options: .transitionCrossDissolve,
				animations: { self.imageView.image = image },
				completion: nil)
		} else {
			imageView.image = image
		}
	}
}
