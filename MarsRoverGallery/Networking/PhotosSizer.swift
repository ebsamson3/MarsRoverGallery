//
//  PhotosSizer.swift
//  MarsRoverGallery
//
//  Created by Edward Samson on 11/6/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import UIKit

class PhotosSizer: UICollectionViewLayout {

	static func size(
		photos: [Photo],
		completion: @escaping ([Photo]) -> Void)
	{
		guard !photos.isEmpty else {
			completion([])
			return
		}
		
		var sizedPhotos = photos
		
		let group = DispatchGroup()
		
		sizedPhotos.enumerated().forEach { (index, photo) in
			
			group.enter()
			
			DispatchQueue.global(qos: .userInitiated).async {
				
				guard
					let imageUrl = URL(string: photo.imageUrl),
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
					sizedPhotos[index].size = size
					group.leave()
				}
			}
		}
		group.notify(queue: .main) {
			completion(sizedPhotos)
		}
	}
}
