//
//  WaterfallCollectionViewController.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/6/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

/// A view controller for a standard waverfall collection view
class WaterfallCollectionViewController: UIViewController {

	//MARK: Private variables
	private let viewModel: WaterfallCollectionViewModel
	private var flowLayout = CHTCollectionViewWaterfallLayout()
	
	//MARK: Views
	
	@objc lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(
			frame: .zero,
			collectionViewLayout: flowLayout)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.prefetchDataSource = self
		return collectionView
	}()
	
	//MARK: Lifecycle
	
	init(viewModel: WaterfallCollectionViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// In the view did load we perform any required bindings to the collection view model.  One this is done we reload the data to sync the view controller and the view model
	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.registerCells(collectionView: collectionView)
		viewModel.registerHeaders(collectionView: collectionView)
		
		viewModel.insertItems = { [weak self] indexPaths in
			self?.collectionView.insertItems(at: indexPaths)
		}
		
		viewModel.reloadData = { [weak self] in
			self?.collectionView.reloadData()
		}
		
		viewModel.reloadSections = { [weak self] indexSet in
			self?.collectionView.reloadSections(indexSet)
		}
		
		viewModel.performBatchUpdates = { [weak self] updates in
			self?.collectionView.performBatchUpdates({
				updates()
			})
			
		}
		
		collectionView.reloadData()
		configure()
	}
	
	//MARK: Layout configuration
	
	private func configure() {
		view.backgroundColor = .background
		collectionView.backgroundColor = .background
		
		view.addSubview(collectionView)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		
		collectionView.topAnchor.constraint(
			equalTo: view.topAnchor)
			.isActive = true
		collectionView.trailingAnchor.constraint(
			equalTo: view.trailingAnchor)
			.isActive = true
		collectionView.bottomAnchor.constraint(
			equalTo: view.bottomAnchor)
			.isActive = true
		collectionView.leadingAnchor.constraint(
			equalTo: view.leadingAnchor)
			.isActive = true
	}
}

//MARK: UICollectionViewDataSource
extension WaterfallCollectionViewController: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return viewModel.numberOfSections
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.numberOfItems(inSection: section)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let itemViewModel = viewModel.viewModelForItem(at: indexPath)
		let cell = itemViewModel.cellInstance(
			collectionView: collectionView,
			indexPath: indexPath)
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		switch kind {
		case UICollectionView.elementKindSectionHeader:
			let headerViewModel = viewModel.viewModelForHeader(at: indexPath)
			let header = headerViewModel?.headerInstance(
				collectionView: collectionView,
				indexPath: indexPath) ?? UICollectionReusableView()
			return header
		default:
			return UICollectionReusableView()
		}
	}
}

//MARK: UICollectionViewDelegate
extension WaterfallCollectionViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		viewModel.didSelectItem(at: indexPath)
	}
}

//MARK: WaterfallLayoutDelegate
extension WaterfallCollectionViewController: CHTCollectionViewDelegateWaterfallLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		viewModel.sizeForItem(at: indexPath)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
		viewModel.columnCount(forSection: section)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsFor section: Int) -> UIEdgeInsets {
		viewModel.insets(forSection: section)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForHeaderIn section: Int) -> CGFloat {
		viewModel.heightForHeader(inSection: section)
	}
}

//MARK: UICollectionViewPrefetchingDelegate
extension WaterfallCollectionViewController: UICollectionViewDataSourcePrefetching {
	func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
		viewModel.prefetchItems(at: indexPaths)
	}
	
	func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
		viewModel.cancelPrefetchingForItems(at: indexPaths)
	}
}

//MARK: UIScrollviewDelegate
extension WaterfallCollectionViewController: UIScrollViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		viewModel.scrollViewDidScroll(scrollView)
	}
	
}
