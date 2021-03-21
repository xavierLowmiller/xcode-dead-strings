import XCTest
@testable import DeadStrings

final class ExtractDeadStringsTests: XCTestCase {
    func testExtractDeadStrings() {
        let url = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("MixedObjCProjectForLocalizedString")

        let deadStringData = extractDeadStrings(at: url)

        XCTAssertEqual(deadStringData.deadStrings, ["dead_string", "en_only", "de_only"])
        XCTAssertEqual(deadStringData.stringsByStringsFile.count, 4)
    }
}
