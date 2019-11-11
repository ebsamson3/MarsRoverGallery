//
//  SearchSettingsCollectionViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//
//
import UIKit

/// View model for search settings view
class SearchSettingsCollectionViewModel {

	//MARK: Collection View Sections
	enum Section: Int, CaseIterable {
		case spacer
		case selectRover
		case selectCamera
		case selectDate
		
		var title: String? {
			switch self {
			case .spacer:
				return ""
			case .selectRover:
				return "Select Rover"
			case .selectCamera:
				return "Select Camera"
			case .selectDate:
				return "Select Date"
			}
		}
	}
	
	var numberOfSections: Int = Section.allCases.count
	
	//MARK: Cell View Models
	
	// Create a header view model for each section
	lazy var headerViewModels: [Section: SettingsSectionHeaderViewModel] = Dictionary(
		uniqueKeysWithValues: Section.allCases.compactMap { section in
			guard let title = section.title else {
				return nil
			}
			let key = section
			let value = SettingsSectionHeaderViewModel(title: title)
			return (key, value)
		}
	)

	// Button-containing view model for selecting the rover for our search request
	lazy var roverSettingCellViewModels: [SelectorCellViewModel<Rover.Name>] = Rover.Name.allCases.map { roverName in
		let viewModel = SelectorCellViewModel(value: roverName)
		viewModel.isActive = roverName == selectedRover
		viewModel.selectionHandler = { [weak self] in
			self?.selectedRover = roverName
		}
		return viewModel
	}
	
	// Button-containing view model for selecting the camera for our search request
	lazy var cameraSettingCellViewModels: [SelectorCellViewModel<Camera.Name>] = Camera.Name.allCases.map { cameraName in
		let viewModel = SelectorCellViewModel(value: cameraName)
		viewModel.isActive = cameraName == selectedCamera
		viewModel.selectionHandler = { [weak self] in
			self?.selectedCamera = cameraName
		}
		return viewModel
	}
	
	// Camera view models + a spacer cell so to center the last camera setting cell horizontally
	lazy var adjustedCameraCellViewModels: [ItemRepresentable] = {
		var cellViewModels: [ItemRepresentable] = cameraSettingCellViewModels
		cellViewModels.insert(LabelCellViewModel(), at: 9)
		return cellViewModels
	}()

	// Slider cell view model for selecting the photos request date
	lazy var dateSettingCellViewModel: DateSettingCellViewModel = {
		let viewModel = DateSettingCellViewModel()
		viewModel.setCurrentValue(to: selectedDate)
		return viewModel
	}()

	private let cellViewModelTypes: [ItemRepresentable.Type] = [
		SelectorCellViewModel<Rover.Name>.self,
		LabelCellViewModel.self,
		DateSettingCellViewModel.self
	]
	
	private let sectionHeaderTypes: [CollectionHeaderRepresentable.Type] = [
		SettingsSectionHeaderViewModel.self
	]
	
	//MARK: Networking
	
	let photosController: PaginatedPhotosController
	let manifestStore: ManifestStore
	
	//MARK: Current search settings
	
	var selectedRover: Rover.Name { didSet { didSelectRover() }}
	var selectedCamera: Camera.Name { didSet { didSelectCamera() }}
	var selectedDate: PhotosRequest.DateOption
	var manifest: Manifest? = nil { didSet { didSetManifest() }}
	
	init(
		photosController: PaginatedPhotosController,
		manifestStore: ManifestStore)
	{
		self.photosController = photosController
		self.manifestStore = manifestStore
		
		let photosRequest = photosController.photosRequest
		
		self.selectedRover = photosRequest?.roverName ?? .curiosity
		self.selectedCamera = photosRequest?.cameraName ?? .any
		self.selectedDate = photosRequest?.dateOption ?? .latest
		
		didSelectRover()
	}
	
	//MARK: Handling state changes
	
	/// Handles rover selection
	func didSelectRover() {
		// Select rover
		roverSettingCellViewModels.forEach { viewModel in
			if viewModel.value != selectedRover {
				viewModel.isActive = false
			} else {
				viewModel.isActive = true
			}
		}
		
		//Update camera availability
		setAvailableCameras()
		
		// Fetch manifest if it hasn't been done already
		//TODO: Add alert for when manifest fetch fails
		setManifest()
	}
	
	/// On camera selection, deselect all but the selected camera
	func didSelectCamera() {
		cameraSettingCellViewModels.forEach { viewModel in
			let camera = viewModel.value
			viewModel.isActive = selectedCamera == camera
		}
	}
	
	/// Set date setting manifest to current manifest
	func didSetManifest() {
		dateSettingCellViewModel.manifest = manifest
	}
	
	/// Set availiable cameras in response to a rover selection change. If the currently selected camera is set to unavailable, change the camera setting to "ANY"
	func setAvailableCameras() {
		let availableCameras = selectedRover.availableCameras
		
		cameraSettingCellViewModels.forEach { viewModel in
			
			let cameraName = viewModel.value
			
			if availableCameras.contains(cameraName) {
				viewModel.isAvailable = true
			} else {
				if selectedCamera == cameraName {
					selectedCamera = .any
				}
				viewModel.isAvailable = false
			}
		}
	}
	
	/// Get a local manifest if available, otherwise fetch the manifest and set afterwards
	func setManifest() {
		let rover = selectedRover
		
		if let manifest = manifestStore.fetchedManifest(forRover: rover) {
			self.manifest = manifest
			return
		}
		
		manifest = nil
		
		manifestStore.fetchManifest(forRover: rover) { [weak self] result in
			switch result {
			case .failure(let error):
				print(error.localizedDescription)
			case .success(let newManifest):
				guard self?.selectedRover == rover else {
					return
				}
				self?.manifest = newManifest
			}
		}
	}
	
	/// Handles settings submission. Sets a new photo request based on the settings values
	func onSubmit() {
		do {
			let photosRequest = try PhotosRequest(
				roverName: selectedRover,
				cameraName: selectedCamera,
				dateOption: dateSettingCellViewModel.getCurrentValue())
			
			photosController.photosRequest = photosRequest
			photosController.fetchNextPage()
			
		} catch {
			print(error.localizedDescription)
		}
	}
	
	func onCancel() {}
}
	
extension SearchSettingsCollectionViewModel: WaterfallCollectionViewModel {
	
	func registerHeaders(collectionView: UICollectionView) {
		for sectionHeaderType in sectionHeaderTypes {
			sectionHeaderType.registerHeader(collectionView: collectionView)
		}
	}

	func registerCells(collectionView: UICollectionView) {
		for cellViewModelType in cellViewModelTypes {
			cellViewModelType.registerCell(collectionView: collectionView)
		}
	}
	
	//MARK: UICollectionViewDataSource

	func numberOfItems(inSection section: Int) -> Int {
		guard let sectionType = Section.init(rawValue: section) else {
			fatalError("Invalid section")
		}

		switch sectionType {
		case .spacer:
			return 0
		case .selectRover:
			return roverSettingCellViewModels.count
		case .selectCamera:
			return adjustedCameraCellViewModels.count
		case .selectDate:
			return 1
		}
	}

	func viewModelForItem(at indexPath: IndexPath) -> ItemRepresentable {
		let section = indexPath.section
		let row = indexPath.row
		guard let sectionType = Section.init(rawValue: section) else {
			fatalError("Invalid section")
		}

		switch sectionType {
		case .spacer:
			fatalError("No view models in spacer section")
		case .selectRover:
			return roverSettingCellViewModels[row]
		case .selectCamera:
			return adjustedCameraCellViewModels[row]
		case .selectDate:
			return dateSettingCellViewModel
		}
	}
	
	func viewModelForHeader(at indexPath: IndexPath) -> CollectionHeaderRepresentable? {
		let section = indexPath.section
		guard let sectionType = Section.init(rawValue: section) else {
			return nil
		}
		return headerViewModels[sectionType]
	}
	
	//MARK: WaterfallLayoutDelegate
	
	func columnCount(forSection section: Int) -> Int {
		guard let sectionType = Section.init(rawValue: section) else {
			fatalError("Invalid section")
		}

		switch sectionType {
		case .spacer:
			return 1
		case .selectRover:
			return 3
		case .selectCamera:
			return 3
		case .selectDate:
			return 1
		}
	}

	func sizeForItem(at indexPath: IndexPath) -> CGSize {
		let section = indexPath.section
		guard let sectionType = Section.init(rawValue: section) else {
			fatalError("Invalid section")
		}

		switch sectionType {
		case .spacer:
			return CGSize.zero
		case .selectRover, .selectCamera:
			return CGSize(width: 0, height: 30)
		case .selectDate:
			return CGSize(width: 0, height: 120)
		}
	}
	
	func heightForHeader(inSection section: Int) -> CGFloat {
		guard
			let title = Section.init(rawValue: section)?.title,
			!title.isEmpty
		else {
			return 0
		}
		
		return 44.0
	}
	
	func insets(forSection section: Int) -> UIEdgeInsets {

		let insetSize = Constants.Spacing.large
		
		return UIEdgeInsets(
			top: insetSize,
			left: insetSize,
			bottom: insetSize,
			right: insetSize)
	}
}
