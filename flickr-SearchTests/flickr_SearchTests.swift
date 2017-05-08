//
//  flickr_SearchTests.swift
//  flickr-SearchTests
//
//  Created by Paul Tangen on 5/7/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import XCTest
@testable import flickr_Search

class flickr_SearchTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFlickrAPIRequest() {
        
        let testForFlickrDataExpectation = expectation(description: "A pass here means flickr responded successfully.")
        
        APIClient.searchFlickr(tags: "goat") { response in
        
            // verify flickr replied to the request
            XCTAssertNotNil(response)
            XCTAssertNotEqual(response, "error", "fetch request should not return error")
            
            if response == "success" || response == "invalidJSON-Retry" || response == "noItemsFound" {
                testForFlickrDataExpectation.fulfill()
            }
            
            // verify the datasource was populated by the search results
            let itemsFromFlickr = DataStore.sharedInstance.items.count
            XCTAssertNotEqual(itemsFromFlickr, 0, "Error, no items generated from the search request")
        }
        
        // triggered when no reply from the server
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("testForFlickrDataExpectation waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testGetValueFromDescription() {
        
        // verifies that the app can parse out the width and height of the image.
        let sampleDescription = "<p><a href=\"https://www.flickr.com/people/robertclifford/\">Robert Clifford</a> posted a photo:</p> <p><a href=\"https://www.flickr.com/photos/robertclifford/34146023520/\" title=\"Scenic Vista\"><img src=\"https://farm5.staticflickr.com/4165/34146023520_b607c4bea2_m.jpg\" width=\"240\" height=\"151\" alt=\"Scenic Vista\" /></a></p> <p>Pemigewasset overlook on the Kancamagus Highway.</p>"
        
        // width
        let width: Int = APIClient.getValueFromDesc(descriptionEncoded: sampleDescription, imgTagAttribute: "width")
        width != 240 ? XCTFail("Unable to parse width from HTML tag in item description.") : ()
        
        // height
        let height: Int = APIClient.getValueFromDesc(descriptionEncoded: sampleDescription, imgTagAttribute: "height")
        height != 151 ? XCTFail("Unable to parse height from HTML tag in item description.") : ()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
