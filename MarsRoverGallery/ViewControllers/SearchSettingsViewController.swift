//
//  SearchSettingsViewController.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class SearchSettingsViewController: UIViewController {
	
	private var kvoContext = 0
	
	private let viewModel: SearchSettingsCollectionViewModel
	private let collectionViewController: WaterfallCollectionViewController
	
	private lazy var footerView: SettingsFooterView = {
		let footerView = SettingsFooterView()
		footerView.delegate = self
		return footerView
	}()
	
	@objc private var collectionView: UICollectionView {
		return collectionViewController.collectionView
	}
	
	init(viewModel: SearchSettingsCollectionViewModel) {
		self.viewModel = viewModel
		collectionViewController = WaterfallCollectionViewController(
			viewModel: viewModel)
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configure()
	}
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		
        addObserver(
			self,
			forKeyPath: #keyPath(collectionView.contentSize),
			options: .new,
			context: &kvoContext)

    }

    override func viewDidDisappear(_ animated: Bool) {
        removeObserver(
			self,
			forKeyPath: #keyPath(collectionView.contentSize))
        super.viewDidDisappear(animated)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if
			context == &kvoContext,
			keyPath == #keyPath(collectionView.contentSize),
            let contentSize = change?[NSKeyValueChangeKey.newKey] as? CGSize
		{
            self.popoverPresentationController?
				.presentedViewController
				.preferredContentSize = CGSize(
					width: contentSize.width,
					height: contentSize.height + footerView.frame.height)
        }
    }
	
	private func configure() {
		view.backgroundColor = .background
		
		guard let collectionView = collectionViewController.view else {
			return
		}
		
		addChild(collectionViewController)
		collectionViewController.didMove(toParent: self)
		
		view.addSubview(collectionView)
		view.addSubview(footerView)
		
		
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		footerView.translatesAutoresizingMaskIntoConstraints = false
		
		collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		
		footerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
		footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
	}
}

extension SearchSettingsViewController: SettingsFooterViewDelegate {
	func settingsFooterDidCancel() {
		viewModel.onCancel()
		dismiss(animated: true)
	}
	
	func settingsFooterDidSubmit() {
		viewModel.onSubmit()
		dismiss(animated: true)
	}
}
