//
//  AutosizingCollectionViewController.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//
//
//import UIKit
//
//class AutosizingCollectionViewController: UIViewController {
//	
//	private var flowLayout: UICollectionViewFlowLayout = {
//		let flowLayout = UICollectionViewFlowLayout()
//		flowLayout.estimatedItemSize = CGSize(width: 1.0, height: 1.0)
//		flowLayout.scrollDirection = .vertical
//		return flowLayout
//	}()
//	
//	private lazy var collectionView: UICollectionView = {
//		let collectionView = UICollectionView(
//			frame: .zero,
//			collectionViewLayout: flowLayout)
//		collectionView.delegate = self
//		collectionView.dataSource = self
//		return collectionView
//	}()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//}
//
//extension AutosizingCollectionViewController: UICollectionViewDataSource {
//	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//		<#code#>
//	}
//	
//	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//		<#code#>
//	}
//}
//
//extension AutosizingCollectionViewController: UICollectionViewDelegate {
//	
//}
