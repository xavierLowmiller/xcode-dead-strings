import XCTest
@testable import XcodeDeadStrings

final class DeadStringsDataTests: XCTestCase {
    func testExtractDeadStrings() throws {
        // Given
        let url = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("MixedObjCProjectForLocalizedString")

        // When
		let deadStringData = try DeadStringsData(url: url)

        // Then
        XCTAssertEqual(deadStringData.deadStrings, ["dead_string", "en_only", "de_only"])
        XCTAssertEqual(deadStringData.aliveStrings.count, 38)
        XCTAssertEqual(deadStringData.localizedStringResults.count, 24)
        XCTAssertEqual(deadStringData.stringsToDelete.count, 2)
        let locations: [LocationStringResult] = deadStringData.stringsToDelete.reduce(into: []) {
            $0 += $1.value
        }

        XCTAssertEqual(locations.map { $0.lineNumber }, [14, 17, 14, 17])


        XCTAssertEqual(deadStringData.descriptionByFile, """
        Found dead strings:

        \(url.path)/MixedObjCProjectForLocalizedString/de.lproj/Localizable.strings:
        de_only
        dead_string

        \(url.path)/MixedObjCProjectForLocalizedString/en.lproj/Localizable.strings:
        dead_string
        en_only
        """)

        XCTAssertEqual(deadStringData.xcodeWarnings.sorted(), [
            "\(url.path)/MixedObjCProjectForLocalizedString/de.lproj/Localizable.strings:14: warning: 'dead_string' looks unused\nDelete it or add the comment \'no_dead_string\'",
            "\(url.path)/MixedObjCProjectForLocalizedString/de.lproj/Localizable.strings:17: warning: 'de_only' looks unused\nDelete it or add the comment \'no_dead_string\'",
            "\(url.path)/MixedObjCProjectForLocalizedString/en.lproj/Localizable.strings:14: warning: 'dead_string' looks unused\nDelete it or add the comment \'no_dead_string\'",
            "\(url.path)/MixedObjCProjectForLocalizedString/en.lproj/Localizable.strings:17: warning: 'en_only' looks unused\nDelete it or add the comment \'no_dead_string\'"
        ])
    }
}
