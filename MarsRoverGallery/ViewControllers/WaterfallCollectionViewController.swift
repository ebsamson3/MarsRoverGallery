//
//  WaterfallCollectionViewController.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/6/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class WaterfallCollectionViewController: UIViewController {
	
	let viewModel: CollectionViewModel
	
	private var flowLayout = CHTCollectionViewWaterfallLayout()
	
	private lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(
			frame: .zero,
			collectionViewLayout: flowLayout)
		collectionView.delegate = self
		collectionView.dataSource = self
		return collectionView
	}()
	
	init(viewModel: CollectionViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		
		viewModel.insertItems = { [weak self] indexPaths in
			self?.collectionView.insertItems(at: indexPaths)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension WaterfallCollectionViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.numberOfItems(inSection: section)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return viewModel.cellForItem(at: indexPath)
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
}
