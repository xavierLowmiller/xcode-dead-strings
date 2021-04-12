import XCTest
@testable import DeadStrings

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
        XCTAssertEqual(deadStringData.aliveStrings.count, 54)
        XCTAssertEqual(deadStringData.localizedStringsAndLocations.count, 20)
        XCTAssertEqual(deadStringData.stringsToDelete.count, 2)
        let locations: [LocationInFile] = deadStringData.stringsToDelete.reduce(into: []) {
            $0 += $1.value
        }

        XCTAssertEqual(locations.map { $0.lineNumber }, [14, 17, 14, 17])


        XCTAssertEqual(deadStringData.descriptionByFile, """
        Found dead strings:

        /Users/xaverlohmueller/Developer/DeadStrings/Tests/MixedObjCProjectForLocalizedString//MixedObjCProjectForLocalizedString/de.lproj/Localizable.strings:
        de_only
        dead_string

        /Users/xaverlohmueller/Developer/DeadStrings/Tests/MixedObjCProjectForLocalizedString//MixedObjCProjectForLocalizedString/en.lproj/Localizable.strings:
        dead_string
        en_only
        """)
    }
}
