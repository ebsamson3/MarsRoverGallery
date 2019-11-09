//
//  TableViewController.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/8/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

import UIKit

class TableViewController: UIViewController {
	let viewModel: TableViewModel
	
	private var cellHeights = [IndexPath: CGFloat]()
	
	@objc lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.dataSource = self
		tableView.delegate = self
		tableView.alwaysBounceVertical = false
		tableView.rowHeight = UITableView.automaticDimension
		tableView.insetsContentViewsToSafeArea = false
		tableView.tableFooterView = UIView()
		return tableView
	}()
	
	init(viewModel: TableViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		viewModel.registerCells(tableView: tableView)
		viewModel.reloadData = { [weak self] in
			self?.tableView.reloadData()
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}
	
    private var kvoContext = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver(self, forKeyPath: #keyPath(tableView.contentSize), options: .new, context: &kvoContext)

    }

    override func viewDidDisappear(_ animated: Bool) {
        removeObserver(self, forKeyPath: #keyPath(tableView.contentSize))
        super.viewDidDisappear(animated)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &kvoContext, keyPath == #keyPath(tableView.contentSize),
            let contentSize = change?[NSKeyValueChangeKey.newKey] as? CGSize  {
            self.popoverPresentationController?.presentedViewController.preferredContentSize = contentSize
        }
    }
	
	func setup() {
		view.backgroundColor = .background
		
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
	}
}

extension TableViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.numberOfSections
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfRows(inSection: section)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellViewModel = viewModel.getCellViewModel(at: indexPath)
		let cell = cellViewModel.cellInstance(tableView: tableView, indexPath: indexPath)
		cell.layoutIfNeeded()
		let cellHeight = cell.systemLayoutSizeFitting(cell.contentView.bounds.size).height
		cellHeights.updateValue(cellHeight, forKey: indexPath)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return viewModel.title(forSection: section)
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if self.tableView(tableView, titleForHeaderInSection: section) == nil {
			return 0.0
		} else {
			return 40.0
		}
	}
}


extension TableViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return cellHeights[indexPath] ?? 100
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		viewModel.didSelectRow(at: indexPath)
	}
	
	func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		viewModel.shouldHighlightRow(at: indexPath)
	}
}
