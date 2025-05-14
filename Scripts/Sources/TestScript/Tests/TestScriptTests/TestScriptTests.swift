// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

@testable import TestScript
import TestScriptMocks
import SwiftyScripty
import SwiftyScriptyMocks
import XCTest

final class TestScriptTests: XCTestCase {
    var sut: TestScript!
    @InjectedMock(\.shell) var shellDependency: ShellMock
    override func setUp() {
        super.setUp()
        sut = TestScript()
    }
    func testExample() {
        // GIVEN
        // WHEN
        sut.main(args: [])
        // THEN
        XCTAssertTrue(shellDependency.printColorTextCalled)
    }
}
