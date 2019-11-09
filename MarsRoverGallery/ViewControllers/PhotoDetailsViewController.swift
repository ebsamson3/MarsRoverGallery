//
//  PhotoDetailsViewController.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/8/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
	
	private let viewModel: PhotoDetailsViewModel
	
	private let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.clipsToBounds = true
		return imageView
	}()
	
	private var imageViewBottomConstraint: NSLayoutConstraint?
	
	private lazy var tableViewController = TableViewController(viewModel: viewModel)
	
	var imageHeightToViewHeight: CGFloat = 0.6
	
	private var imageOffsetRatio: CGFloat {
		return 1 - max(min(imageHeightToViewHeight, 1), 0)
	}

	init(viewModel: PhotoDetailsViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		viewModel.didSetImage = { [weak self] image in
			self?.imageView.image = image
		}
		
		imageView.image = viewModel.image
		
		configure()
	}
	
	override func viewWillTransition(
		to size: CGSize,
		with coordinator: UIViewControllerTransitionCoordinator)
	{
		super.viewWillTransition(to: size, with: coordinator)
		
		let willLandscape = size.width > size.height
		
		imageView.alpha = 0
		
		imageViewBottomConstraint?.constant = willLandscape
			? 0 : -imageOffsetRatio * size.height
		
		imageView.contentMode = willLandscape
			? .scaleAspectFit : .scaleAspectFill
		
		coordinator.animate(alongsideTransition: { _ in
		}) { [weak self] _ in
			self?.imageView.alpha = 1
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let isLandscape = view.bounds.width > view.bounds.height
		imageViewBottomConstraint = imageView.bottomAnchor.constraint(
			equalTo: view.bottomAnchor)
		imageViewBottomConstraint?.constant = isLandscape
			? 0 : -imageOffsetRatio * view.bounds.height
		imageViewBottomConstraint?.isActive = true
		imageView.contentMode = isLandscape ? .scaleAspectFit : .scaleAspectFill
	}
	
	private func configure() {
		view.backgroundColor = .background
		
		addChild(tableViewController)
		tableViewController.didMove(toParent: self)
		
		guard let tableView = tableViewController.view else {
			return
		}
		
		view.addSubview(imageView)
		view.addSubview(tableView)
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		imageView.topAnchor.constraint(
			equalTo: view.topAnchor)
			.isActive = true
		imageView.trailingAnchor.constraint(
			equalTo: view.trailingAnchor)
			.isActive = true
		imageView.leadingAnchor.constraint(
			equalTo: view.leadingAnchor)
			.isActive = true
		
		tableView.topAnchor.constraint(
			equalTo: imageView.bottomAnchor)
			.isActive = true
		tableView.trailingAnchor.constraint(
			equalTo: view.trailingAnchor)
			.isActive = true
		tableView.bottomAnchor.constraint(
			equalTo: view.bottomAnchor)
			.isActive = true
		tableView.leadingAnchor.constraint(
			equalTo: view.leadingAnchor)
			.isActive = true
	}
}
