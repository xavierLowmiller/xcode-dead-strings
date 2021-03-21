import Foundation

func extractStrings(from string: String, isPlist: Bool = false) -> Set<Substring> {
    let pattern = isPlist ? #"(?<=<key>).*(?=<\/key>)"# : #"(?<=\")[\s\w]+(?=\")"#

    return Set(string.matches(for: pattern))
}

func extractStrings(fromFileAt url: URL) -> Set<Substring> {
    guard let data = FileManager.default.contents(atPath: url.path) else { return [] }
    let contents = String(decoding: data, as: UTF8.self)
    return extractStrings(from: contents, isPlist: url.pathExtension == "plist")
}

func extractStrings(fromFilesAt url: URL) -> Set<Substring> {
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
        for suffix in [".swift", ".m", ".mm", ".plist"] {
            if hasSuffix(suffix) {
                return true
            }
        }
        return false
    }
}
