import XCTest
@testable import SwiftNet

final class SwiftNetTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftNet().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
