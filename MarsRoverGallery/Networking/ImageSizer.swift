//
//  PhotosSizer.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/6/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

/// Sizes remote images.
// This allows us to layout our waterfall image gallery based on image size prior to loading out images
class ImageSizer: UICollectionViewLayout {

	/// A static function that takes an array of image urls and returns the size (if any) of the image at each URL.
	static func size(
		imageUrlStrings: [String],
		completion: @escaping ([String: CGSize]) -> Void)
	{
		guard !imageUrlStrings.isEmpty else {
			completion([:])
			return
		}
		
		var sizes = [String: CGSize]()
		
		// A dispatch group is used to ensure that all size requests finish before executing the completion handler
		let group = DispatchGroup()
		
		imageUrlStrings.forEach { imageUrlString in
			
			group.enter()
			
			DispatchQueue.global(qos: .userInitiated).async {
				
				// Getting size information by reading the image header
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
