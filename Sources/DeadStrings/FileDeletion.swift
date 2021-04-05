import Foundation

func deleteDeadStrings(_ deadStrings: Set<Substring>, in file: String) -> String {
    var file = file
    let pattern = ##"""
        (?<=;)\s*+                # After a Semicolon
        (?>                       # Skip...
          \s                      # whitespace
          | \/\*[^(?>\*\/)]*+\*\/ # block comments
          | \/\/.*                # double-slash coments
        )*+                       # until the string begins
        "(?<key>.*)"              # The key
        \s*+=[^;]*                # If match, skip everything...
        "\s*+;(?=\s*+)            # ...until the next localized String value ends
        """##

    let regex = try! NSRegularExpression(
        pattern: pattern,
        options: [.allowCommentsAndWhitespace, .anchorsMatchLines]
    )
    let range = NSRange(file.startIndex..<file.endIndex, in: file)

    var rangesToDelete: [Range<String.Index>] = []

    regex.enumerateMatches(in: file, range: range) { match, flags, stop in
        guard let match = match,
              match.range.location != NSNotFound,
              let rangeToDelete = Range(match.range, in: file)
        else { return }

        let keyNSRange = match.range(withName: "key")
        guard keyNSRange.location != NSNotFound,
              let keyRange = Range(keyNSRange, in: file)
        else { return }

        let key = file[keyRange]
        if deadStrings.contains(key) {
            rangesToDelete.append(rangeToDelete)
        }
    }

    for range in rangesToDelete.reversed() {
        file.removeSubrange(range)
    }
    return file
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
