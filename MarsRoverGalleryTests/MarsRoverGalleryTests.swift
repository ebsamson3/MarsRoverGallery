//
//  MarsRoverGalleryTests.swift
//  MarsRoverGalleryTests
//
//  Created by Edward Samson on 11/4/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import XCTest
@testable import MarsRoverGallery

class MarsRoverGalleryTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	func testPhotosDecoding() {
		
		// Given: Local photo JSON data
		let jsonFileName = "example_photo"
		let testBundle = Bundle(for: type(of: self))
		
		guard let path = testBundle.path(forResource: jsonFileName, ofType: "json") else {
			XCTFail("failed to location json with fileName: \(jsonFileName)")
			return
		}
		
		guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
			XCTFail("failed to read json at path: \(path)")
			return
		}
		
		//When: Decoding the entire photo response, which contains a decoded array of photo objects
		
		guard let photoResponse = try? JSONDecoder().decode(PhotosResponse.self, from: data) else {
			XCTFail("Failed to decode photo response")
			return
		}
		
		// Then: we should have a non-zero amount of photos in the response
		XCTAssert(photoResponse.photos.count > 0)
	}
	
	func testManifestDecoding() {
		
		// Given: Local mission manifest JSON data
		let jsonFileName = "example_manifest"
		let testBundle = Bundle(for: type(of: self))
		
		guard let path = testBundle.path(forResource: jsonFileName, ofType: "json") else {
			XCTFail("failed to location json with fileName: \(jsonFileName)")
			return
		}
		
		guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
			XCTFail("failed to read json at path: \(path)")
			return
		}
		
		//When: Decoding the manifest photo response
		guard let manifestResponse = try? JSONDecoder().decode(ManifestResponse.self, from: data) else {
			XCTFail("Failed to decode manifest response")
			return
		}
		
		//Then: We should have a manifest with individual entries
		XCTAssert(manifestResponse.manifest.entries.count > 0)
	}
	
	//TODO: Make photos request url builder test
	
	func testPhotosFetch() {
		
		// Given: A photo request for front hazard photos taken by curiosity on Sol 1000
		guard let photosRequest = try? PhotosRequest(
			roverName: .curiosity,
			cameraName: .fhaz,
			dateOption: .sol(1000))
		else {
			XCTFail("Invalid photosRequest")
			return
		}
		
		var result: Result<[Photo], Error>?
		
		let expectation = self.expectation(description: "Fetch photos completed")
		
		// When: We perform a API requenst using the photo request
		photosRequest.fetch() { newResult in
			result = newResult
			switch newResult {
			case .failure(let error):
				XCTFail(error.localizedDescription)
			case .success(let photos):
				// Then: We should recieve a non-zero amount of photos in return
				XCTAssert(photos.count > 0)
			}
			
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(result, "No fetch result recieved")
	}
	
	func testManifestFetch() {
		
		// Given: A request for Curiosity's mission manifest
		let manifestRequest = ManifestRequest(roverName: .curiosity)
		
		var result: Result<Manifest, Error>?
		
		let expectation = self.expectation(description: "Fetch manifest completed")
		
		// When: We perform an API request using the photo request
		manifestRequest.fetch() { newResult in
			result = newResult
			switch newResult {
			case .failure(let error):
				XCTFail(error.localizedDescription)
			case .success(let manifest):
				// Then: we should recieve a manifest with a non-zero amount of entries
				XCTAssert(manifest.entries.count > 0)
			}
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(result, "No fetch result recieved")
	}
	
	func testPaginatedPhotosRequest() {
		
		guard let photosRequest = try? PhotosRequest(
			roverName: .curiosity,
			cameraName: .any,
			dateOption: .sol(1000))
		else {
			XCTFail("Invalid photosRequest")
			return
		}
		
		var result: Result<[Photo], Error>?
		
		let expectation = self.expectation(description: "Paginated fetch completed")
	
		// Given: A paginated photo request for any image taken by curiosity on Sol 1000
		let controller = PaginatedPhotosController(
			photosRequest: photosRequest)
		
		// When: We fetch the next page of image
		controller.fetchNextPage { newResult in
			result = newResult
			switch newResult {
			case .failure(let error):
				XCTFail(error.localizedDescription)
			case .success(_):
				// Then: Apon succesfully fetching the first page. The paginated photo status should move to upToDate and the current page should be 2.
				if case .upToDate(_, let nextPage) = controller.status {
					XCTAssertEqual(nextPage, 2)
				} else {
					XCTFail("Invalid status")
				}
			}
			
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(result, "No fetch result recieved")
	}
	
	func testImageSizer() {
		
		// Given: An image url
		let imageUrl = "http://mars.jpl.nasa.gov/msl-raw-images/msss/01000/mcam/1000ML0044631200305217E01_DXXX.jpg"
		
		var size: CGSize?
		
		let expectation = self.expectation(description: "Image sizing completed")
		
		// When: The image sizer checks the size of the iamge at that url
		ImageSizer.size(imageUrlStrings: [imageUrl]) { sizes in
			size = sizes[imageUrl]
			// Then: We should read a non-nil size from the header
			XCTAssertNotNil(size)
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(size)
	}
	
	func testImageStore() {
		
		// Given: An image url
		let imageUrl = "http://mars.jpl.nasa.gov/msl-raw-images/msss/01000/mcam/1000ML0044631200305217E01_DXXX.jpg"
		
		var image: UIImage?
		
		let imageStore = ImageStore()
		
		let expectation = self.expectation(description: "Image fetch completed")
		
		// When: We request an image at that url
		imageStore.fetchImage(withUrl: imageUrl) { result in
			switch result {
			case .failure(let error):
				XCTFail("Image fetch failed with error: \(error.localizedDescription)")
			case.success(let newImage):
				//Then: We should recieve an image in the response data
				image = newImage
			}
			
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(image)
	}
	
	func testManifestStore() {
		
		// Given: A manifest store
		let manifestStore = ManifestStore()
		
		let expectation = self.expectation(description: "Manifest fetch completed")
		
		var manifest: Manifest?
		
		// When: We request curiosity's mission manifest using the manifest store
		manifestStore.fetchManifest(forRover: .curiosity) { result in
			switch result {
			case .failure(let error):
				XCTFail("Image fetch failed with error: \(error.localizedDescription)")
			case.success(let newManifest):
				// Then: we should recieve a manifest in the response
				manifest = newManifest
			}
			
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(manifest)
	}
}
