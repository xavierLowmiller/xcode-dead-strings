import Foundation

func deleteDeadStrings(_ deadStrings: Set<Substring>, in file: String) -> String {
    let file = NSMutableString(string: file)
    for stringToDelete in deadStrings {
        let escaped = NSRegularExpression.escapedPattern(for: String(stringToDelete))
            .replacingOccurrences(of: "\n", with: #"\n"#)
            .replacingOccurrences(of: " ", with: #"\s"#)
        let pattern = ##"""
        # After a Semicolon
        (?<=;)\s*+
        # Skip whitespace and comments until the string begins
        (\s|\/\*[^(*/)]*\*\/)*+\"
        """## + escaped + ##"""
        # If match, skip everything...
        \"\s*+=[^;]*
        # ...until the next localized String value ends
        \"\s*+;(?=\s*+)
        """##

        let regex = try! NSRegularExpression(
            pattern: pattern,
            options: [.allowCommentsAndWhitespace, .dotMatchesLineSeparators]
        )
        let range = NSRange(location: 0, length: file.length)
        regex.replaceMatches(in: file, options: [], range: range, withTemplate: "")
    }
    return file as String
}

func deleteDeadStrings(_ deadStrings: Set<Substring>, inFileAt url: URL) throws {
    let data = FileManager.default.contents(atPath: url.path) ?? Data()
    let withDeadStringsDeleted = deleteDeadStrings(deadStrings, in: String(decoding: data, as: UTF8.self))
    guard FileManager.default.isWritableFile(atPath: url.path) else { return }
    let fileUrl = URL(fileURLWithPath: url.path)
    try withDeadStringsDeleted.data(using: .utf8)?.write(to: fileUrl)
}

public func deleteDeadStrings(_ deadStrings: Set<Substring>, inFilesAt url: URL) throws {
    let enumerator = FileManager.default.enumerator(atPath: url.path)

    while let filename = enumerator?.nextObject() as? String {
        guard filename.hasSupportedSuffix else { continue }
        let fileUrl = url.appendingPathComponent(filename)

        try deleteDeadStrings(deadStrings, inFileAt: fileUrl)
    }
}

private extension String {
    var hasSupportedSuffix: Bool {
        for suffix in [".strings"] {
            if hasSuffix(suffix) {
                return true
            }
        }
        return false
    }
}
