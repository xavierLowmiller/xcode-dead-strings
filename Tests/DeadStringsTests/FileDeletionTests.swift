import XCTest
@testable import DeadStrings

final class FileDeletionTests: XCTestCase {
    private let testFile = """
    /* Some valid strings */
    "push_first_vc" = "Push Swift View Controller";
    "my_view_controller" = "My View Controller";

    /* Dead strings */
    "dead_string" = "A dead string";
    "dead_string_2" = "A dead string";

    "valid_string" = "Valid String";

    "dead_string_3" = "A dead string";
    """
    private let testStringsFileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        .appendingPathComponent("testFile.strings")

    override func setUpWithError() throws {
        try super.setUpWithError()

        // Create file to delete dead keys from
        try testFile.data(using: .utf8)!.write(to: testStringsFileURL)
    }

    override func tearDownWithError() throws {
        // Cleanup
        if FileManager.default.fileExists(atPath: testStringsFileURL.path) {
            try FileManager.default.removeItem(at: testStringsFileURL)
        }

        try super.tearDownWithError()
    }

    func testFileDeletionInFileContents() {
        // Given
        let deadStrings: Set<Substring> = ["dead_string", "dead_string_2", "dead_string_3"]

        let expected = """
        /* Some valid strings */
        "push_first_vc" = "Push Swift View Controller";
        "my_view_controller" = "My View Controller";

        "valid_string" = "Valid String";
        """

        // When
        let withDeadStringsDeleted = deleteDeadStrings(deadStrings, in: testFile)

        // Then
        XCTAssertEqual(withDeadStringsDeleted, expected)
    }

    func testFileDeletionInFile() throws {
        // Given
        let deadStrings: Set<Substring> = ["dead_string", "dead_string_2", "dead_string_3"]

        let expected = """
        /* Some valid strings */
        "push_first_vc" = "Push Swift View Controller";
        "my_view_controller" = "My View Controller";

        "valid_string" = "Valid String";
        """

        // When
        try deleteDeadStrings(deadStrings, inFileAt: testStringsFileURL)

        // Then
        let data = try Data(contentsOf: testStringsFileURL)
        XCTAssertEqual(String(decoding: data, as: UTF8.self), expected)
    }
}
