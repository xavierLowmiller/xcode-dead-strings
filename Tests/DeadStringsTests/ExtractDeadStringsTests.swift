import XCTest
@testable import DeadStrings

final class ExtractDeadStringsTests: XCTestCase {
    func testExtractDeadStrings() {
        let url = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("MixedObjCProjectForLocalizedString")

        let deadStrings = extractDeadStrings(at: url)

        XCTAssertEqual(deadStrings, ["dead_string", "en_only", "de_only"])
    }
}
