import Foundation

public struct LocationInFile: Equatable {
    let fileUrl: URL
    let range: Range<String.Index>
    let lineNumber: Int
}

func extractLocalizedKeys(from contents: String, url: URL) -> [(key: Substring, location: LocationInFile)] {
    let pattern = ##"""
        (?<=;|^)\s*+              # After a Semicolon
        (?>                       # Skip...
          \s                      # whitespace
          | \/\*[^(?>\*\/)]*+\*\/ # block comments
          | \/\/.*                # double-slash coments
        )*+                       # until the string begins
        "(?<key>.*)"              # The key
        \s*+=.*                   # If match, skip everything...
        "\s*+;(?=\s*+)            # ...until the next localized String value ends
        """##

    let regex = try! NSRegularExpression(
        pattern: pattern,
        options: [.allowCommentsAndWhitespace, .anchorsMatchLines]
    )
    let range = NSRange(contents.startIndex..<contents.endIndex, in: contents)

    var keysAndLocations: [(Substring, LocationInFile)] = []

    var lastPosition = contents.startIndex
    var currentLine = 1

    regex.enumerateMatches(in: contents, range: range) { match, flags, stop in
        guard let match = match,
              match.range.location != NSNotFound,
              let rangeToDelete = Range(match.range, in: contents)
        else { return }

        let keyNSRange = match.range(withName: "key")
        guard keyNSRange.location != NSNotFound,
              let keyRange = Range(keyNSRange, in: contents)
        else { return }

        let key = contents[keyRange]
        let lineNumber = contents.lineNumber(of: keyRange,
                                             lastPosition: &lastPosition,
                                             currentLine: &currentLine)

        let location = LocationInFile(fileUrl: url, range: rangeToDelete, lineNumber: lineNumber)
        keysAndLocations.append((key, location))
    }

    return keysAndLocations
}

func extractLocalizedKeys(fromFileAt url: URL) -> [(key: Substring, location: LocationInFile)] {
    guard let data = FileManager.default.contents(atPath: url.path) else { return [] }
    let contents = String(decoding: data, as: UTF8.self)
    return extractLocalizedKeys(from: contents, url: url)
}

public func extractLocalizedKeys(fromFilesAt url: URL) -> [(key: Substring, location: LocationInFile)] {
    let enumerator = FileManager.default.enumerator(atPath: url.path)

    var keysAndLocations: [(Substring, LocationInFile)] = []
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
