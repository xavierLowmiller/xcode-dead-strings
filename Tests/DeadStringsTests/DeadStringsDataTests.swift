import DeadStrings
import XCTest

final class DeadStringsDataTests: XCTestCase {
    func testDeadStringDataDescription() {
        let fileURL1 = URL(string: "path/to/my/project/file1.strings")!
        let fileURL2 = URL(string: "path/to/my/project/file2.strings")!
        let fileURL3 = URL(string: "path/to/my/project/file3.strings")!
        let data = DeadStringsData(
            deadStrings: ["dead", "string"],
            stringsByStringsFile: [
                fileURL1: ["dead", "string", "alive string"],
                fileURL2: ["dead", "alive string"],
                fileURL3: ["alive string"]
            ]
        )

        let expected = """
        Found dead strings:

        \(fileURL1.path):
        dead
        string

        \(fileURL2.path):
        dead
        """

        XCTAssertEqual(data.descriptionByFile, expected)
    }

    func testEmptyDeadStringDataDescription() {
        let fileURL1 = URL(string: "path/to/my/project/file1.strings")!
        let fileURL2 = URL(string: "path/to/my/project/file2.strings")!
        let data = DeadStringsData(
            deadStrings: [],
            stringsByStringsFile: [
                fileURL1: ["alive string"],
                fileURL2: ["alive string"]
            ]
        )

        let expected = "No dead strings found!"

        XCTAssertEqual(data.descriptionByFile, expected)
    }
}
