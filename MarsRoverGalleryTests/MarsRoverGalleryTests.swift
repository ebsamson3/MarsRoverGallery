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
		
		let expectation = self.expectation(description: "Fetch completed")
		
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
				if case .upToDate(let nextPage) = controller.status {
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
	
	func testPhotoSizer() {
		
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
		
		guard let photosResponse = try? JSONDecoder().decode(PhotosResponse.self, from: data) else {
			XCTFail("Failed to decode photo response")
			return
		}
		
		var size: CGSize?
		
		let expectation = self.expectation(description: "Photos sizing completed")
		
		PhotosSizer.size(photos: photosResponse.photos) { sizedPhotos in
			size = sizedPhotos[0].size
			XCTAssertNotNil(size)
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(size)
	}

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
