//
//  HomePageTest.swift
//  GithubAPIUITests
//
//  Created by Bing Guo on 2023/1/26.
//

import XCTest

let app = XCUIApplication()

final class HomePageTest: XCTestCase {

    override func setUpWithError() throws {
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchUser() throws {
        HomePage(app)
            .tapSearchBar()
            .typeOnSearchBar(with: "Hello")
            .clickSearch()
            .waitForCompletionOfData()

        XCTAssertTrue(HomePage(app).countOfData() > 0)
    }

    func testSearchNonexistentUser() throws {
        HomePage(app)
            .tapSearchBar()
            .typeOnSearchBar(with: "AFAEZDGX")
            .clickSearch()
            .waitForBackgroundTitle()

        XCTAssertTrue(HomePage(app).countOfData() == 0)
        XCTAssertTrue(HomePage(app).backgroundTitle.label == "No Data Found")
    }
}
