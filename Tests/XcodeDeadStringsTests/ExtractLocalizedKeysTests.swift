import XCTest
@testable import XcodeDeadStrings

final class ExtractLocalizedKeysTests: XCTestCase {
    func testStringExtractionFromSwiftFile() {
        // Given
        let localizedStringsFile = ##"""
        /* Swift View Controller */
        "my_swift_view_controller" = "My Swift View Controller";
        "push_second_vc" = "Show SwiftUI View";
        "Some sentence (that includes) punctuation.?!" = "Some sentence (that includes) punctuation.?!";
        "and a comment" = "and a comment"; // Comment
        "what\nabout\nnewlines" = "what\nabout\nnewlines";
        "ümlauts-dash;:.\n()" = "ümlauts-dash;:\n()";
        "can we do \"quotation marks\"?" = "a string";
        """##
        let url = URL(string: "/some/valid/path")!

        // When
        let parsedStrings = extractLocalizedKeys(from: localizedStringsFile, url: url).map(\.key)

        // Then
        XCTAssert(parsedStrings.contains("my_swift_view_controller"))
        XCTAssert(parsedStrings.contains("push_second_vc"))
        XCTAssert(parsedStrings.contains("Some sentence (that includes) punctuation.?!"))
        XCTAssert(parsedStrings.contains("and a comment"))
        XCTAssert(parsedStrings.contains(#"what\nabout\nnewlines"#))
        XCTAssert(parsedStrings.contains(#"ümlauts-dash;:.\n()"#))
        XCTAssert(parsedStrings.contains(#"can we do \"quotation marks\"?"#))
    }

    func testExtractingStringsFromFile() throws {
        let url = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("MixedObjCProjectForLocalizedString")
            .appendingPathComponent("MixedObjCProjectForLocalizedString")
            .appendingPathComponent("en.lproj")
            .appendingPathComponent("Localizable.strings")

        let strings = try extractStrings(fromFileAt: url)

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

        let stringsByFile = extractLocalizedKeys(fromFilesAt: url)
        let strings = Set(stringsByFile.map(\.key))

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
