import Foundation

func extractLocalizedKeys(from string: String) -> Set<Substring> {
    return Set(string.matches(for: ##"""
                (?<=")
                # Match anything that's after a quotation mark...
                .*
                # ...that's followed by a quotation mark, whitespace, and an equals sign
                (?="\s*+=)
                """##))
}

func extractLocalizedKeys(fromFileAt url: URL) -> Set<Substring> {
    guard let data = FileManager.default.contents(atPath: url.path) else { return [] }
    let contents = String(decoding: data, as: UTF8.self)
    return extractLocalizedKeys(from: contents)
}

func extractLocalizedKeys(fromFilesAt url: URL) -> [URL: Set<Substring>] {
    let enumerator = FileManager.default.enumerator(atPath: url.path)

    var strings: [URL: Set<Substring>] = [:]
    while let filename = enumerator?.nextObject() as? String {
        guard filename.hasSupportedSuffix else { continue }
        let fileUrl = url.appendingPathComponent(filename)
        strings[fileUrl] = extractLocalizedKeys(fromFileAt: fileUrl)
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
