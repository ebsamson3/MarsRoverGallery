//
//  WaterfallCollectionViewModel.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/7/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

protocol WaterfallCollectionViewModel: CollectionViewModel {
	func columnCount(forSection section: Int) -> Int
}
