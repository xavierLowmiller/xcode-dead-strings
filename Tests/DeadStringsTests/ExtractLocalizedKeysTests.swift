import XCTest
@testable import DeadStrings

final class ExtractLocalizedKeysTests: XCTestCase {
    func testStringExtractionFromSwiftFile() {
        let localizedStringsFile = ##"""
        /* Swift View Controller */
        "my_swift_view_controller" = "My Swift View Controller";
        "push_second_vc" = "Show SwiftUI View";
        """##

        let parsedStrings = extractLocalizedKeys(from: localizedStringsFile)

        XCTAssert(parsedStrings.contains("my_swift_view_controller"))
        XCTAssert(parsedStrings.contains("push_second_vc"))
    }

    func testExtractingStringsFromFile() {
        let url = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("MixedObjCProjectForLocalizedString")
            .appendingPathComponent("MixedObjCProjectForLocalizedString")
            .appendingPathComponent("en.lproj")
            .appendingPathComponent("Localizable.strings")

        let strings = extractStrings(fromFileAt: url)

        // ObjC View Controller
        XCTAssert(strings.contains("push_first_vc"))
        XCTAssert(strings.contains("my_view_controller"))

        // Swift View Controller
        XCTAssert(strings.contains("my_swift_view_controller"))
        XCTAssert(strings.contains("push_second_vc"))

        // SwiftUI View
        XCTAssert(strings.contains("login_title"))
        XCTAssert(strings.contains("mail_address_placeholder"))
        XCTAssert(strings.contains("password_placeholder"))
        XCTAssert(strings.contains("swiftui_view_title"))

        // Dead strings
        XCTAssert(strings.contains("dead_string"))
    }

    func testExtractingStringsFromActualProject() {
        let url = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("MixedObjCProjectForLocalizedString")

        let strings = extractLocalizedKeys(fromFilesAt: url)

        // ObjC View Controller
        XCTAssert(strings.contains("push_first_vc"))
        XCTAssert(strings.contains("my_view_controller"))

        // Swift View Controller
        XCTAssert(strings.contains("my_swift_view_controller"))
        XCTAssert(strings.contains("push_second_vc"))

        // SwiftUI View
        XCTAssert(strings.contains("login_title"))
        XCTAssert(strings.contains("mail_address_placeholder"))
        XCTAssert(strings.contains("password_placeholder"))
        XCTAssert(strings.contains("swiftui_view_title"))

        // Dead strings
        XCTAssert(strings.contains("dead_string"))

        // de only
        XCTAssert(strings.contains("de_only"))

        // en only
        XCTAssert(strings.contains("en_only"))
    }
}
