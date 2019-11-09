//
//  SearchSettingsCollectionViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//
//
import UIKit

class SearchSettingsCollectionViewModel: WaterfallCollectionViewModel {

	enum Section: Int, CaseIterable {
		case spacer
		case selectRover
		case selectCamera
		case selectDate
		case submit
		
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
			default:
				return nil
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

	lazy var roverCellViewModels: [SelectorCellViewModel] = Rover.Name.allCases.map { roverName in
		SelectorCellViewModel(title: roverName.rawValue)
	}

	lazy var cameraCellViewModels: [SelectorCellViewModel] = Camera.Name.allCases.map { cameraName in
		SelectorCellViewModel(title: cameraName.rawValue)
	}

	lazy var sliderCellViewModel = SliderCellViewModel()
	
	lazy var submitCellViewModels = ["Cancel", "Submit"].map { title in
		SelectorCellViewModel(title: title)
	}

	var numberOfSections: Int = Section.allCases.count

	private let cellViewModelTypes: [ItemRepresentable.Type] = [
		SelectorCellViewModel.self,
		SliderCellViewModel.self
	]
	
	private let sectionHeaderTypes: [CollectionHeaderRepresentable.Type] = [
		SettingsSectionHeaderViewModel.self
	]

	func columnCount(forSection section: Int) -> Int {
		guard let sectionType = Section.init(rawValue: section) else {
			fatalError("Invalid section")
		}

		switch sectionType {
		case .selectRover, .selectCamera:
			return 3
		case .selectDate:
			return 1
		case .submit, .spacer:
			return 2
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
			return roverCellViewModels.count
		case .selectCamera:
			return cameraCellViewModels.count
		case .selectDate:
			return 1
		case .submit:
			return submitCellViewModels.count
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
			return roverCellViewModels[row]
		case .selectCamera:
			return cameraCellViewModels[row]
		case .selectDate:
			return sliderCellViewModel
		case .submit:
			return submitCellViewModels[row]
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
			return CGSize(width: 0, height: 44)
		case .selectDate:
			return CGSize(width: 0, height: 120)
		case .submit:
			return CGSize(width: 0, height: 32)
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
