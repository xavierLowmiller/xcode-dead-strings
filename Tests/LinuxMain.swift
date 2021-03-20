import XCTest

import DeadStringsTests

var tests = [XCTestCaseEntry]()
tests += DeadStringsTests.allTests()
XCTMain(tests)
