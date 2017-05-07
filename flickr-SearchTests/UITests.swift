//
//  UITests.swift
//  flickr-Search
//
//  Created by Paul Tangen on 5/7/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import KIF

class UITests : KIFTestCase {
    
    /*
     The test covers 3 scenarios:
     1. Verify the default content appears as expected. The results are somewhat random so unable to verify the data.
     2. Search for an item with a unique tag. Verify that the expected data was returned.
     3. Search for a set of terms that do not exist. Verify the "No data found" dialog was displayed, click ok.
     */
    
    func testFlickrSearch() {
        
        // 1. verify default search term exists and data was returned
        var searchField = tester().waitForView(withAccessibilityLabel: "searchField")
        tester().expect(searchField, toContainText: "cat")
        
        // tap item in second cell and verify detail view appears
        var indexPath = IndexPath(row: 1, section: 0)
        tester().tapRow(at: indexPath, inTableViewWithAccessibilityIdentifier: "searchResultsTableView")
        tester().waitForView(withAccessibilityLabel: "detailViewInst")
        
        // go back to search results
        tester().tapScreen(at: CGPoint(x: 40, y: 50)) // tap back button in nav bar
        tester().waitForView(withAccessibilityLabel: "searchResultsViewInst")
        searchField = tester().waitForView(withAccessibilityLabel: "searchField")
        
        // 2. search for item with unique tag
        tester().clearTextFromView(withAccessibilityLabel: "searchField")
        tester().enterText("Sdq2212fr", intoViewWithAccessibilityLabel: "searchField")
        tester().tapView(withAccessibilityLabel: "getSearchResultsButtonForUITest")
        
        // one image is returned for sdq2212fr, tap that item and verify detail view appears
        indexPath = IndexPath(row: 0, section: 0)
        tester().tapRow(at: indexPath, inTableViewWithAccessibilityIdentifier: "searchResultsTableView")
        tester().waitForView(withAccessibilityLabel: "detailViewInst")
        
        // detail view displayed, verify content exists in the fields
        let dimensionsLabel = tester().waitForView(withAccessibilityLabel: "dimensionsLabel")
        tester().expect(dimensionsLabel, toContainText: "240 x 160")
        
        let dateLabel = tester().waitForView(withAccessibilityLabel: "dateLabel")
        tester().expect(dateLabel, toContainText: "May 05, 2017")
        
        let timeLabel = tester().waitForView(withAccessibilityLabel: "timeLabel")
        tester().expect(timeLabel, toContainText: "12:59 PM")
        
        let titleTextView = tester().waitForView(withAccessibilityLabel: "titleTextView")
        tester().expect(titleTextView, toContainText: "snyder brook, new hampshire\n\njtr27 posted a photo:  sigma sd quattro, sigma 30mm f1.4 dc hsm art.   thank you for visiting.")
        
        // back to search results page
        tester().tapScreen(at: CGPoint(x: 40, y: 50)) // tap back button in nav bar
        tester().waitForView(withAccessibilityLabel: "searchResultsViewInst")
        
        // 3. search for item with tags that dont return results, verify no items found message appears with OK button.
        tester().clearTextFromView(withAccessibilityLabel: "searchField")
        tester().enterText("Terms that dont return results", intoViewWithAccessibilityLabel: "searchField")
        tester().tapView(withAccessibilityLabel: "getSearchResultsButtonForUITest")
        tester().tapView(withAccessibilityLabel:"okButton")
    }
}
