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
		case dateOption
		case selectDate
		
		var title: String? {
			switch self {
			case .spacer:
				return ""
			case .selectRover:
				return "Select Rover"
			case .selectCamera:
				return "Select Camera"
			case .dateOption:
				return "Select Date"
			case .selectDate:
				return nil
			}
		}
	}
	
	enum DateSetting: String, CaseIterable {
		case latest = "Latest"
		case sol = "Sol"
		case earthDate = "Earth Date"
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
	
	lazy var dateOptionSettingViewModels: [SelectorCellViewModel] = DateSetting.allCases.map {
		return SelectorCellViewModel(value: $0)
	}

	lazy var sliderCellViewModel = SliderCellViewModel()

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
		
		self.selectedRover = photosRequest.roverName
		self.selectedCamera = photosRequest.cameraName
		self.selectedDate = photosRequest.dateOption
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
		dateOptionSettingViewModels.forEach { viewModel in
			let dateOption = viewModel.value
			
			if manifest == nil {
				viewModel.isActive = dateOption == .latest ? true : false
				viewModel.isAvailable = dateOption == .latest ? true : false
			} else {
				viewModel.isAvailable = true
			}
		}
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
		case .dateOption:
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
		case .dateOption:
			return 3
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
		case .dateOption:
			return dateOptionSettingViewModels[row]
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
		case .selectRover, .selectCamera, .dateOption:
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
		guard let sectionType = Section.init(rawValue: section) else {
			fatalError("Invalid section")
		}
		let insetSize = Constants.Spacing.large
		
		switch sectionType {
		case .spacer, .selectRover, .selectCamera, .selectDate:
			return UIEdgeInsets(
			top: insetSize,
			left: insetSize,
			bottom: insetSize,
			right: insetSize)
		case .dateOption:
			return UIEdgeInsets(
			top: insetSize,
			left: insetSize,
			bottom: 0,
			right: insetSize)
		}
	}
}
