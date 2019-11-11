//
//  SearchSettingsViewController.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/9/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

/// A container view controller for a waterfall collection view controller than works for pop-up or normal modal presentations
class SearchSettingsCollectionViewController: UIViewController {
	
	private var kvoContext = 0
	
	//MARK: Views / Child ViewControllers
	
	private let collectionViewController: WaterfallCollectionViewController
	
	// Footer for cancel/submit buttons
	private lazy var footerView: SettingsFooterView = {
		let footerView = SettingsFooterView()
		footerView.delegate = self
		return footerView
	}()
	
	// @objc collectionView variable for observation
	@objc private var collectionView: UICollectionView {
		return collectionViewController.collectionView
	}
	
	private let viewModel: SearchSettingsCollectionViewModel
	
	//MARK: Lifecycle
	
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
	
	// When the view will appear begin tracking the colleciton view content size
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		
        addObserver(
			self,
			forKeyPath: #keyPath(collectionView.contentSize),
			options: .new,
			context: &kvoContext)

    }

	// Clean up collection view content size observer
    override func viewDidDisappear(_ animated: Bool) {
        removeObserver(
			self,
			forKeyPath: #keyPath(collectionView.contentSize))
        super.viewDidDisappear(animated)
    }

	// When the collection view content size changes, set the preferred size of the view controller to adjust for it so that the any pop up controllers are sized to fit the collection view + footer view
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
	
	//MARK: Configure layout
	private func configure() {
		view.backgroundColor = .background
		
		guard let collectionView = collectionViewController.view else {
			return
		}
		
		// Add waterfall collection view as a child controller
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

// MARK: Settings footer delegate
extension SearchSettingsCollectionViewController: SettingsFooterViewDelegate {
	// Handle cancel button press
	func settingsFooterDidCancel() {
		viewModel.onCancel()
		dismiss(animated: true)
	}
	
	// Handle submit button press
	func settingsFooterDidSubmit() {
		viewModel.onSubmit()
		dismiss(animated: true)
	}
}
