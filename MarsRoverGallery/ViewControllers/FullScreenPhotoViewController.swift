//
//  FullScreenPhotoViewController.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/8/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

/// View controller for displaying a full screen photo image
class FullScreenPhotoViewController: UIViewController {
	
	// MARK: Views
	let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		return imageView
	}()
	
	let propertyListView = PropertyListView()
	
	private let viewModel: FullScreenPhotoViewModel
	
	// MARK: Lifecycle
	
	init(viewModel: FullScreenPhotoViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// Completing any view model bindings then request an photo image + properties from the view model
	override func viewDidLoad() {
		super.viewDidLoad()
		
		viewModel.didSetImage = { [weak self] image in
			self?.imageView.image = image
		}
		
		imageView.image = viewModel.image
		propertyListView.properties = viewModel.photoDetails
		
		configure()
	}
	
	// Hide the navigation controller on appear
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.isTranslucent = true
	}

	// Show the navigation controller when the view dissapears
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
		navigationController?.navigationBar.shadowImage = nil
	}
	
	// On rotation, hide the image. Otherise you get weird image distortion due to view layout
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
	
	//MARK: Configure layout
	
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
