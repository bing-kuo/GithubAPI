import Foundation
import XCTest

class TestHelper {
    static func expect(element: XCUIElement, status: UIStatus, withIn timeout: TimeInterval = 20) {
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: status.rawValue), object: element)
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)

        if result == .timedOut {
            XCTFail(expectation.description)
        }
    }
}

enum UIStatus: String {
    case exist = "exists == true"
    case notExist = "exists == false"
    case selected = "selected == true"
    case notSelected = "selected == false"
    case hittable = "isHittable == true"
    case unhittable = "isHittable == false"
}
