//
//  PhotosSizer.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/6/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class ImageSizer: UICollectionViewLayout {

	static func size(
		imageUrlStrings: [String],
		completion: @escaping ([String: CGSize]) -> Void)
	{
		guard !imageUrlStrings.isEmpty else {
			completion([:])
			return
		}
		
		var sizes = [String: CGSize]()
		
		let group = DispatchGroup()
		
		imageUrlStrings.forEach { imageUrlString in
			
			group.enter()
			
			DispatchQueue.global(qos: .userInitiated).async {
				
				guard
					let imageUrl = URL(string: imageUrlString),
					let imageSource = CGImageSourceCreateWithURL(imageUrl as CFURL, nil),
					let imageHeader = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary?,
					let pixelWidth = imageHeader[kCGImagePropertyPixelWidth] as? Int,
					let pixelHeight = imageHeader[kCGImagePropertyPixelHeight] as? Int
				else {
					group.leave()
					return
				}
				
				let size = CGSize(width: pixelWidth, height: pixelHeight)
				
				DispatchQueue.main.async {
					sizes[imageUrlString] = size
					group.leave()
				}
			}
		}
		group.notify(queue: .main) {
			completion(sizes)
		}
	}
}
