import XCTest
@testable import DeadStrings

final class FileDeletionTests: XCTestCase {
    private let testFile = #"""
    /* Some valid strings */
    "push_first_vc" = "Push Swift View Controller";
    "my_view_controller" = "My View Controller";

    /* Dead strings */
    "dead_string" = "A dead string";
    "dead_string_2" = "A dead string";

    "valid_string" = "Valid String";

    "dead_string_3" = "A dead string";

    // double-slash comment
    "dead_string_4" = "A dead string";

    "dead\nstring\nwith\nnewlines" = "dead\nstring\nwith\nnewlines";

    /*
      Multi
      Line
      Comment
    */
    "dead_multiline_comment_string" = "dead multiline comment string";

    /* String with whitespace key */
    "dead string" = "dead string with whitespace key";

    /* Multiple */
    /* Comments. */
    "dead_multiple_comments_string" = "dead string with multiple comments";

    "dead string that's \"just\" a \n\n sentence." = "dead string with multiple comments";

    "valid_string_2" = "Valid String";
    """#

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
        let deadStrings: Set<Substring> = [
            "dead_string",
            "dead_string_2",
            "dead_string_3",
            "dead_string_4",
            #"dead\nstring\nwith\nnewlines"#,
            "dead_multiline_comment_string",
            "dead string",
			"dead_multiple_comments_string",
            #"dead string that's \"just\" a \n\n sentence."#
        ]

        let expected = """
        /* Some valid strings */
        "push_first_vc" = "Push Swift View Controller";
        "my_view_controller" = "My View Controller";

        "valid_string" = "Valid String";

        "valid_string_2" = "Valid String";
        """

        // When
        let withDeadStringsDeleted = deleteDeadStrings(deadStrings, in: testFile)

        // Then
        XCTAssertEqual(withDeadStringsDeleted, expected)
    }

    func testFileDeletionInFile() throws {
        // Given
        let deadStrings: Set<Substring> = [
            "dead_string",
            "dead_string_2",
            "dead_string_3",
            "dead_string_4",
            #"dead\nstring\nwith\nnewlines"#,
            "dead_multiline_comment_string",
            "dead string",
			"dead_multiple_comments_string",
            #"dead string that's \"just\" a \n\n sentence."#
        ]

        let expected = """
        /* Some valid strings */
        "push_first_vc" = "Push Swift View Controller";
        "my_view_controller" = "My View Controller";

        "valid_string" = "Valid String";

        "valid_string_2" = "Valid String";
        """

        // When
        try deleteDeadStrings(deadStrings, inFileAt: testStringsFileURL)

        // Then
        let data = try Data(contentsOf: testStringsFileURL)
        XCTAssertEqual(String(decoding: data, as: UTF8.self), expected)
    }
}
