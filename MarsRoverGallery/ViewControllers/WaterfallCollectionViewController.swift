//
//  WaterfallCollectionViewController.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/6/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class WaterfallCollectionViewController: UIViewController {
	
	let viewModel: WaterfallCollectionViewModel
	
	private var flowLayout = CHTCollectionViewWaterfallLayout()
	
	private lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(
			frame: .zero,
			collectionViewLayout: flowLayout)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.prefetchDataSource = self
		return collectionView
	}()
	
	init(viewModel: WaterfallCollectionViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.registerCells(collectionView: collectionView)
		
		viewModel.insertItems = { [weak self] indexPaths in
			self?.collectionView.insertItems(at: indexPaths)
		}
		
		viewModel.reloadData = { [weak self] in
			self?.collectionView.reloadData()
		}
		
		collectionView.reloadData()
		configure()
	}
	
	private func configure() {
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
}

extension WaterfallCollectionViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		viewModel.didSelectItem(at: indexPath)
	}
}

extension WaterfallCollectionViewController: CHTCollectionViewDelegateWaterfallLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		viewModel.sizeForItem(at: indexPath)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
		viewModel.columnCount(forSection: section)
	}
}

extension WaterfallCollectionViewController: UICollectionViewDataSourcePrefetching {
	func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
		viewModel.prefetchItems(at: indexPaths)
	}
	
	func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
		viewModel.cancelPrefetchingForItems(at: indexPaths)
	}
}

extension WaterfallCollectionViewController: UIScrollViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		viewModel.scrollViewDidScroll(scrollView)
	}
	
}
