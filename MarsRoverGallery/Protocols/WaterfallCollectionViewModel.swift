//
//  WaterfallCollectionViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/7/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

protocol WaterfallCollectionViewModel: CollectionViewModel {
	func columnCount(forSection section: Int) -> Int
	func heightForHeader(inSection section: Int) -> CGFloat
}

extension WaterfallCollectionViewModel {
	func heightForHeader(inSection section: Int) -> CGFloat {
		return 0.0
	}
}
