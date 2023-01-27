//
//  GithubAPIUITests.swift
//  GithubAPIUITests
//
//  Created by Bing Guo on 2022/12/20.
//

import XCTest

final class GithubAPIUITests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    /*
     1. App launch
     2. Tap the search bar
     3. Typing "Apple" in the search bar
     4. Tap the search button on the keyboard
     5. Wait for the data loaded from the API
     6. Verify the table view count is not empty
     */
    func testSearchUser() throws {
        let app = XCUIApplication()
        app.launch()

        let searchBar = app.searchFields["Search username"]
        searchBar.tap()
        searchBar.typeText("Apple")

        let searchButton = app.buttons["Search"]
        searchButton.tap()

        let cells = app.tables.cells
        TestHelper.expect(element: cells.firstMatch, status: .exist, withIn: 3)
        XCTAssertTrue(cells.count > 0)
    }
}
