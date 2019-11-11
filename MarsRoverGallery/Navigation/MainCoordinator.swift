//
//  MainCoordinator.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/8/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

/// Handles navigation and dependency injection of the model and networking controllers
class MainCoordinator: NSObject {
	
	let navigationController: UINavigationController
	
	private lazy var paginatedPhotosController = PaginatedPhotosController()
	private lazy var imageStore = ImageStore()
	private lazy var manifestStore = ManifestStore()
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		
		styleNavBar()
		
		// Initial request for app
		let photosRequest = try? PhotosRequest(
			roverName: .curiosity,
			cameraName: .any,
			dateOption: .sol(1500))
		
		// Object for handling paginated photo requests
		paginatedPhotosController.photosRequest = photosRequest
		
		// Prefetch and store manifests on App start
		Rover.Name.allCases.forEach { roverName in
			manifestStore.fetchManifest(forRover: roverName)
		}
		
		showPhotoGallery()
	}
	
	/// Shows mars rover photo gallery
	private func showPhotoGallery() {
		
		let viewModel = PhotosCollectionViewModel(
			paginatedPhotosController: paginatedPhotosController,
			imageStore: imageStore)
		
		viewModel.delegate = self
		
		let viewController = WaterfallCollectionViewController(
			viewModel: viewModel)
		viewController.title = "Rover Gallery"
		
		// Add search button to gallery
		let searchButton = UIBarButtonItem(
			barButtonSystemItem: .search,
			target: self,
			action: #selector(handleSearchButtonPress(sender:)))
		
		viewController.navigationItem.rightBarButtonItem = searchButton
		
		navigationController.pushViewController(viewController, animated: false)
	}
	
	/// Presents search settings apon search button press
	@objc private func handleSearchButtonPress(sender: UIBarButtonItem) {
		
		let viewModel = SearchSettingsCollectionViewModel(
			photosController: paginatedPhotosController,
			manifestStore: manifestStore)
		
		let viewController = SearchSettingsCollectionViewController(viewModel: viewModel)
		
		let deviceIdiom = UIDevice.current.userInterfaceIdiom
		
		// Prepare pop up view controller for IPad
		if deviceIdiom == .pad {
			viewController.modalPresentationStyle = .popover
			viewController.preferredContentSize = CGSize(width: 450, height: 0)
			let popOver = viewController.popoverPresentationController
			popOver?.barButtonItem = sender
		}
		
		navigationController.present(viewController, animated: true)
	}
	
	private func styleNavBar() {
		UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
		UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
		UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
	}
}

extension MainCoordinator: PhotosCollectionViewModelDelegate {
	
	// Shows a full screen version of a selected gallery photo
	func photosCollection(didSelect photo: Photo) {
		
		let viewModel = FullScreenPhotoViewModel(
			photo: photo,
			imageStore: imageStore)
		let viewController = FullScreenPhotoViewController(
			viewModel: viewModel)
		
		navigationController.pushViewController(viewController, animated: true)
	}
}
