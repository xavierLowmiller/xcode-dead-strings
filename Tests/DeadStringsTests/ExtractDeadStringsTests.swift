import XCTest
@testable import DeadStrings

final class DeadStringsDataTests: XCTestCase {
    func testExtractDeadStrings() throws {
        let url = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("MixedObjCProjectForLocalizedString")

		var deadStringData = DeadStringsData(url: url)

        try deadStringData.findDeadStrings()

        XCTAssertEqual(deadStringData.deadStrings, ["dead_string", "en_only", "de_only"])
        XCTAssertEqual(deadStringData.aliveStrings.count, 54)
        XCTAssertEqual(deadStringData.localizedStringsAndLocations.count, 20)

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
