//
//  SearchSettingsCollectionViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//
//
import UIKit

class SearchSettingsCollectionViewModel {

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

	lazy var roverSettingCellViewModels: [SelectorCellViewModel<Rover.Name>] = Rover.Name.allCases.map { roverName in
		let viewModel = SelectorCellViewModel(value: roverName)
		viewModel.isActive = roverName == selectedRover
		viewModel.selectionHandler = { [weak self] in
			self?.selectedRover = roverName
		}
		return viewModel
	}
	
	lazy var cameraSettingCellViewModels: [SelectorCellViewModel<Camera.Name>] = Camera.Name.allCases.map { cameraName in
		let viewModel = SelectorCellViewModel(value: cameraName)
		viewModel.isActive = cameraName == selectedCamera
		viewModel.selectionHandler = { [weak self] in
			self?.selectedCamera = cameraName
		}
		return viewModel
	}
	
	lazy var adjustedCameraCellViewModels: [ItemRepresentable] = {
		var cellViewModels: [ItemRepresentable] = cameraSettingCellViewModels
		cellViewModels.insert(LabelCellViewModel(), at: 9)
		return cellViewModels
	}()

	lazy var sliderCellViewModel: SliderCellViewModel = {
		let viewModel = SliderCellViewModel()
		viewModel.setCurrentValue(to: selectedDate)
		return viewModel
	}()

	var numberOfSections: Int = Section.allCases.count

	private let cellViewModelTypes: [ItemRepresentable.Type] = [
		SelectorCellViewModel<Rover.Name>.self,
		LabelCellViewModel.self,
		SliderCellViewModel.self
	]
	
	private let sectionHeaderTypes: [CollectionHeaderRepresentable.Type] = [
		SettingsSectionHeaderViewModel.self
	]
	
	
	
	let photosController: PaginatedPhotosController
	let manifestStore: ManifestStore
	
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
	
	func didSelectRover() {
		roverSettingCellViewModels.forEach { viewModel in
			if viewModel.value != selectedRover {
				viewModel.isActive = false
			} else {
				viewModel.isActive = true
			}
		}
		
		setAvailableCameras()
		setManifest()
	}
	
	func didSelectCamera() {
		cameraSettingCellViewModels.forEach { viewModel in
			let camera = viewModel.value
			viewModel.isActive = selectedCamera == camera
		}
	}
	
	func didSetManifest() {
		sliderCellViewModel.manifest = manifest
	}
	
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
	
	func onSubmit() {
		do {
			let photosRequest = try PhotosRequest(
				roverName: selectedRover,
				cameraName: selectedCamera,
				dateOption: sliderCellViewModel.getCurrentValue())
			
			photosController.photosRequest = photosRequest
			photosController.fetchNextPage()
			
		} catch {
			print(error.localizedDescription)
		}
	}
	
	func onCancel() {
		
	}
}
	
extension SearchSettingsCollectionViewModel: WaterfallCollectionViewModel {
	
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
			return sliderCellViewModel
		}
	}
	
	func viewModelForHeader(at indexPath: IndexPath) -> CollectionHeaderRepresentable? {
		let section = indexPath.section
		guard let sectionType = Section.init(rawValue: section) else {
			return nil
		}
		return headerViewModels[sectionType]
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

	func didSelectItem(at indexPath: IndexPath) {}
	
	func insets(forSection section: Int) -> UIEdgeInsets {

		let insetSize = Constants.Spacing.large
		
		return UIEdgeInsets(
			top: insetSize,
			left: insetSize,
			bottom: insetSize,
			right: insetSize)
	}
}
