//
//  MainCoordinator.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/8/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class MainCoordinator: NSObject {
	
	let navigationController: UINavigationController
	private lazy var imageStore = ImageStore()
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		showPhotoGallery()
	}
	
	func showPhotoGallery() {
		let photosRequest = try! PhotosRequest(
			roverName: .curiosity,
			cameraName: nil,
			dateOption: .sol(1150))
		
		let paginatedPhotosController = PaginatedPhotosController(photosRequest: photosRequest)
		
		let viewModel = PhotosCollectionViewModel(
			paginatedPhotosController: paginatedPhotosController,
			imageStore: imageStore)
		viewModel.delegate = self
		
		let viewController = WaterfallCollectionViewController(
			viewModel: viewModel)
		viewController.title = "Photo Gallery"
		
		let searchButton = UIBarButtonItem(
			barButtonSystemItem: .search,
			target: self,
			action: #selector(handleBarButtonPress(sender:)))
		
		viewController.navigationItem.rightBarButtonItem = searchButton
		
		navigationController.pushViewController(viewController, animated: false)
	}
	
	@objc private func handleBarButtonPress(sender: UIBarButtonItem) {
		let viewModel = SearchSettingsCollectionViewModel()
		let viewController = SearchSettingsViewController(viewModel: viewModel)
		viewController.modalPresentationStyle = .popover
		viewController.preferredContentSize = CGSize(width: 450, height: 0)
		let popOver = viewController.popoverPresentationController
		popOver?.barButtonItem = sender
		navigationController.present(viewController, animated: true)
	}
}

extension MainCoordinator: PhotosCollectionViewModelDelegate {
	func photosCollection(didSelect photo: Photo) {
//		let viewModel = PhotoDetailsViewModel(
//			photo: photo,
//			imageStore: imageStore)
//
//		let viewController = PhotoDetailsViewController(
//			viewModel: viewModel)
		
		let viewModel = FullScreenPhotoViewModel(
			photo: photo,
			imageStore: imageStore)
		let viewController = FullScreenPhotoViewController(
			viewModel: viewModel)
		
		navigationController.pushViewController(viewController, animated: true)
	}
}
