import Foundation

public struct LocationStringResult: Equatable {
    let fileUrl: URL
    let range: Range<String.Index>
    let lineNumber: Int
    let key: Substring
    let isIgnored: Bool
}

func extractLocalizedKeys(from contents: String, url: URL) -> [LocationStringResult] {
    let pattern = ##"""
        (?<=;|^)\s*+              # After a Semicolon
        (?<comment>
          (?>                       # Skip...
            \s                        # ...whitespace
            | \/\*[^(?>\*\/)]*+\*\/   # ...block comments
            | \/\/.*                  # ...double-slash coments
          )*+                       # until the string begins
        )
        "(?<key>.*)"              # The key
        \s*+=.*                   # If match, skip everything...
        "\s*+;(?=\s*+)            # ...until the next localized String value ends
        """##

    let regex = try! NSRegularExpression(
        pattern: pattern,
        options: [.allowCommentsAndWhitespace, .anchorsMatchLines]
    )
    let range = NSRange(contents.startIndex..<contents.endIndex, in: contents)

    var keysAndLocations: [LocationStringResult] = []

    var lastPosition = contents.startIndex
    var currentLine = 1

    regex.enumerateMatches(in: contents, range: range) { match, flags, stop in
        guard let match = match,
              match.range.location != NSNotFound,
              let rangeToDelete = Range(match.range, in: contents)
        else { return }

        // Key
        let keyNSRange = match.range(withName: "key")
        guard keyNSRange.location != NSNotFound,
              let keyRange = Range(keyNSRange, in: contents)
        else { return }

        let key = contents[keyRange]

        // Comment
        let isIgnored: Bool
        let commentNSRange = match.range(withName: "comment")
        if commentNSRange.location != NSNotFound,
           let commentRange = Range(commentNSRange, in: contents),
           contents[commentRange].contains("no_dead_string") {
            isIgnored = true
        } else {
            isIgnored = false
        }

        let lineNumber = contents.lineNumber(of: keyRange,
                                             lastPosition: &lastPosition,
                                             currentLine: &currentLine)

        let location = LocationStringResult(
            fileUrl: url,
            range: rangeToDelete,
            lineNumber: lineNumber,
            key: key,
            isIgnored: isIgnored
        )
        keysAndLocations.append(location)
    }

    return keysAndLocations
}

func extractLocalizedKeys(fromFileAt url: URL) -> [LocationStringResult] {
    guard let data = FileManager.default.contents(atPath: url.path) else { return [] }
    let contents = String(data: data, encoding: .utf8)
        ?? String(data: data, encoding: .utf16)
        ?? ""
    return extractLocalizedKeys(from: contents, url: url)
}

public func extractLocalizedKeys(fromFilesAt url: URL) -> [LocationStringResult] {
    let enumerator = FileManager.default.enumerator(atPath: url.path)

    var keysAndLocations: [LocationStringResult] = []
    while let filename = enumerator?.nextObject() as? String {
        guard filename.hasSupportedSuffix else { continue }
        let fileUrl = url.appendingPathComponent(filename)
        keysAndLocations += extractLocalizedKeys(fromFileAt: fileUrl)
    }

    return keysAndLocations
}

private extension String {
    var hasSupportedSuffix: Bool {
        return hasSuffix(".strings")
    }

    func lineNumber(of range: Range<Index>, lastPosition: inout Index, currentLine: inout Int) -> Int {
        let line = self[lastPosition..<range.lowerBound].filter { $0 == "\n" }.count + currentLine
        lastPosition = range.upperBound
        currentLine = line
        return line
    }
}
