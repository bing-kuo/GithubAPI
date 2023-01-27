//
//  HomePage.swift
//  GithubAPIUITests
//
//  Created by Bing Guo on 2022/12/31.
//

import Foundation
import XCTest

class Page {
    var app: XCUIApplication

    init(_ app: XCUIApplication) {
        self.app = app
    }
}

class HomePage: Page {
    lazy var searchBar = app.searchFields["Search username"].firstMatch
    lazy var searchButton = app.buttons["Search"].firstMatch
    lazy var tableView = app.tables["HomeTableView"].firstMatch
    lazy var backgroundTitle = app.staticTexts["TableViewBackgroundTitle"].firstMatch

    @discardableResult
    func tapSearchBar() -> Self {
        searchBar.tap()
        return self
    }

    @discardableResult
    func typeOnSearchBar(with text: String) -> Self {
        searchBar.typeText(text)
        return self
    }
    
    @discardableResult
    func clickSearch() -> Self {
        searchButton.tap()
        return self
    }

    @discardableResult
    func waitForCompletionOfData() -> Self {
        TestHelper.expect(element: app.tables.cells.firstMatch, status: .exist, withIn: 3)
        return self
    }

    @discardableResult
    func waitForBackgroundTitle() -> Self {
        TestHelper.expect(element: backgroundTitle, status: .exist, withIn: 3)
        return self
    }

    func countOfData() -> Int {
        return tableView.cells.count
    }
}
