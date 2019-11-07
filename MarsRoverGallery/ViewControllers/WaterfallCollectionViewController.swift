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
	
	private lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView()
		collectionView.delegate = self
		collectionView.dataSource = self
		return collectionView
	}()
	
	init(viewModel: CollectionViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
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

extension WaterfallCollectionViewController: UICollectionViewDelegate {}
