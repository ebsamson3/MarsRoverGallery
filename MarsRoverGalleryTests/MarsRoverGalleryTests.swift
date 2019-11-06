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
	
	//TO-DO: Make photos request url builder test
	
	func testPhotosFetch() {
		
		guard let photosRequest = try? PhotosRequest(
			roverName: .curiosity,
			cameraName: .fhaz,
			dateOption: .latest)
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
			case .success(let photos):
				print(photos.count)
			}
			
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(result, "No fetch result recieved")
	}
	

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
