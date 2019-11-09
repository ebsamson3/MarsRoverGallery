//
//  FullScreenPhotoViewController.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/8/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController {
	
	let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		return imageView
	}()
	
	let propertyListView = PropertyListView()
	
	let viewModel: FullScreenPhotoViewModel
	
	init(viewModel: FullScreenPhotoViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		
		viewModel.didSetImage = { [weak self] image in
			self?.imageView.image = image
		}
		
		imageView.image = viewModel.image
		propertyListView.properties = viewModel.photoDetails
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configure()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.isTranslucent = true
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
		navigationController?.navigationBar.shadowImage = nil
	}
	
	override func viewWillTransition(
		to size: CGSize,
		with coordinator: UIViewControllerTransitionCoordinator)
	{
		super.viewWillTransition(to: size, with: coordinator)
		
		imageView.alpha = 0
		
		coordinator.animate(alongsideTransition: { _ in
			
		}) { [weak self] _ in
			UIView.animate(withDuration: 0.2) {
				
				self?.imageView.alpha = 1
			}
		}
	}
	
	private func configure() {
		view.backgroundColor = .background
		
		view.addSubview(imageView)
		view.addSubview(propertyListView)
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		propertyListView.translatesAutoresizingMaskIntoConstraints = false
		
		let margins = view.layoutMarginsGuide
		
		imageView.topAnchor.constraint(
			equalTo: view.topAnchor)
			.isActive = true
		imageView.trailingAnchor.constraint(
			equalTo: view.trailingAnchor)
			.isActive = true
		imageView.bottomAnchor.constraint(
			equalTo: view.bottomAnchor)
			.isActive = true
		imageView.leadingAnchor.constraint(
			equalTo: view.leadingAnchor)
			.isActive = true
		
		propertyListView.topAnchor.constraint(
			greaterThanOrEqualTo: margins.topAnchor)
			.isActive = true
		propertyListView.trailingAnchor.constraint(
			lessThanOrEqualTo: margins.trailingAnchor)
			.isActive = true
		propertyListView.bottomAnchor.constraint(
			equalTo: margins.bottomAnchor)
			.isActive = true
		propertyListView.leadingAnchor.constraint(
			equalTo: margins.leadingAnchor)
			.isActive = true
	}
}
