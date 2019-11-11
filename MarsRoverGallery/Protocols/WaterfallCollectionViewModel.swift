//
//  WaterfallCollectionViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/7/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

/// Adds methods for definitng waterfall layout paramers to collection view models
protocol WaterfallCollectionViewModel: CollectionViewModel {
	func columnCount(forSection section: Int) -> Int
	func heightForHeader(inSection section: Int) -> CGFloat
}

extension WaterfallCollectionViewModel {
	func heightForHeader(inSection section: Int) -> CGFloat {
		return 0.0
	}
}
