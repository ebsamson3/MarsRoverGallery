//
//  MainCoordinator.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/8/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class MainCoordinator {
	
	let navigationController: UINavigationController
	
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
		let imageStore = ImageStore()
		
		let viewModel = PhotosCollectionViewModel(
			paginatedPhotosController: paginatedPhotosController,
			imageStore: imageStore)
		viewModel.delegate = self
		
		let viewController = WaterfallCollectionViewController(
			viewModel: viewModel)
		viewController.title = "Photo Gallery"
		
		let barButton = UIBarButtonItem(
			title: "Filter Search",
			style: .plain,
			target: self,
			action: #selector(handleBarButtonPress(sender:)))
		
		viewController.navigationItem.rightBarButtonItem = barButton
		
		navigationController.pushViewController(viewController, animated: false)
	}
	
	@objc private func handleBarButtonPress(sender: UIBarButtonItem) {
		let viewController = UITableViewController()
		viewController.view.backgroundColor = .white
		viewController.preferredContentSize = viewController.tableView.contentSize
		viewController.modalPresentationStyle = .popover
		let popOver = viewController.popoverPresentationController
		popOver?.barButtonItem = sender
		navigationController.present(viewController, animated: true)
	}
}

extension MainCoordinator: PhotosCollectionViewModelDelegate {
	func photosCollection(didSelectPhoto: Photo) {
		print("photo selected")
		let viewController = UIViewController()
		viewController.view.backgroundColor = .black
		viewController.title = "Photo Details"
		navigationController.pushViewController(viewController, animated: true)
	}
}
