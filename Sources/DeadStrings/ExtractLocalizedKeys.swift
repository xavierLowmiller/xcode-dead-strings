import Foundation

func extractLocalizedKeys(from string: String) -> Set<Substring> {
    let nsrange = NSRange(string.startIndex..<string.endIndex, in: string)
    let regex = try! NSRegularExpression(pattern: #"(?<=\")[\s\w]+(?=\"\s*=)"#)

    var results: Set<Substring> = []
    regex.enumerateMatches(in: string, options: [], range: nsrange) { (match, _, _) in
        guard let match = match,
              let range = Range(match.range, in: string)
        else { return }

        results.insert(string[range])
    }

    return results
}

func extractLocalizedKeys(fromFileAt url: URL) -> Set<Substring> {
    guard let data = FileManager.default.contents(atPath: url.path) else { return [] }
    let contents = String(decoding: data, as: UTF8.self)
    return extractStrings(from: contents)
}

func extractLocalizedKeys(fromFilesAt url: URL) -> Set<Substring> {
    let enumerator = FileManager.default.enumerator(atPath: url.path)

    var strings: Set<Substring> = []
    while let filename = enumerator?.nextObject() as? String {
        guard filename.hasSupportedSuffix else { continue }
        strings.formUnion(extractStrings(fromFileAt: url.appendingPathComponent(filename)))
    }

    return strings
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
