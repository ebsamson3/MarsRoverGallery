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
		
		guard let _ = try? JSONDecoder().decode(PhotosResponse.self, from: data) else {
			XCTFail("Failed to decode photo response")
			return
		}
	}
	
	func testManifestDecoding() {
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
		
		guard let _ = try? JSONDecoder().decode(ManifestResponse.self, from: data) else {
			XCTFail("Failed to decode manifest response")
			return
		}
	}
	
	//TODO: Make photos request url builder test
	
	func testPhotosFetch() {
		
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
		
		photosRequest.fetch() { newResult in
			result = newResult
			switch newResult {
			case .failure(let error):
				XCTFail(error.localizedDescription)
			case .success(_):
				break
			}
			
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(result, "No fetch result recieved")
	}
	
	func testManifestFetch() {
		
		let manifestRequest = ManifestRequest(roverName: .curiosity)
		
		var result: Result<Manifest, Error>?
		
		let expectation = self.expectation(description: "Fetch manifest completed")
		
		manifestRequest.fetch() { newResult in
			result = newResult
			switch newResult {
			case .failure(let error):
				XCTFail(error.localizedDescription)
			case .success(_):
				break
			}
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(result, "No fetch result recieved")
	}
	
	func testPaginatedPhotosRequest() {
		
		guard let photosRequest = try? PhotosRequest(
			roverName: .curiosity,
			cameraName: nil,
			dateOption: .sol(1000))
		else {
			XCTFail("Invalid photosRequest")
			return
		}
		
		var result: Result<[Photo], Error>?
		
		let expectation = self.expectation(description: "Paginated fetch completed")
	
		let controller = PaginatedPhotosController(
			photosRequest: photosRequest)
		
		controller.fetchNextPage { newResult in
			result = newResult
			switch newResult {
			case .failure(let error):
				XCTFail(error.localizedDescription)
			case .success(_):
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
		
		let imageUrl = "http://mars.jpl.nasa.gov/msl-raw-images/msss/01000/mcam/1000ML0044631200305217E01_DXXX.jpg"
		
		var size: CGSize?
		
		let expectation = self.expectation(description: "Image sizing completed")
		
		ImageSizer.size(imageUrlStrings: [imageUrl]) { sizes in
			size = sizes[imageUrl]
			XCTAssertNotNil(size)
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(size)
	}
	
	func testImageStore() {
		let imageUrl = "http://mars.jpl.nasa.gov/msl-raw-images/msss/01000/mcam/1000ML0044631200305217E01_DXXX.jpg"
		
		var image: UIImage?
		
		let imageStore = ImageStore()
		
		let expectation = self.expectation(description: "Image fetch completed")
		
		imageStore.fetchImage(withUrl: imageUrl) { result in
			switch result {
			case .failure(let error):
				XCTFail("Image fetch failed with error: \(error.localizedDescription)")
			case.success(let newImage):
				image = newImage
			}
			
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(image)
	}
	
	func testManifestStore() {
		
		let manifestStore = ManifestStore()
		
		let expectation = self.expectation(description: "Manifest fetch completed")
		
		var manifest: Manifest?
		
		manifestStore.fetchManifest(forRover: .curiosity) { result in
			switch result {
			case .failure(let error):
				XCTFail("Image fetch failed with error: \(error.localizedDescription)")
			case.success(let newManifest):
				manifest = newManifest
			}
			
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(manifest)
	}

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
