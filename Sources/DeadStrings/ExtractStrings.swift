import Foundation

func extractStrings(from string: String) -> Set<Substring> {
    return Set(string.matches(for: #"(?<=\")[\s\w]+(?=\")"#))
}

func extractStrings(from plistUrl: URL) throws -> Set<Substring> {
    guard let data = FileManager.default.contents(atPath: plistUrl.path) else { return [] }
    return try extractStrings(from: data)
}

func extractStrings(from plistData: Data) throws -> Set<Substring> {
    guard let dict = try PropertyListSerialization.propertyList(from: plistData, format: nil) as? NSDictionary
    else { return [] }
    return dict.allRecursiveKeys
}

func extractStrings(fromFileAt url: URL) throws -> Set<Substring> {
    if url.pathExtension == "plist" {
        return try extractStrings(from: url)
    } else {
        guard let data = FileManager.default.contents(atPath: url.path) else { return [] }
        return extractStrings(from: String(decoding: data, as: UTF8.self))
    }
}

func extractStrings(fromFilesAt url: URL) throws -> Set<Substring> {
    let enumerator = FileManager.default.enumerator(atPath: url.path)

    var strings: Set<Substring> = []
    while let filename = enumerator?.nextObject() as? String {
        guard filename.hasSupportedSuffix else { continue }
        try strings.formUnion(extractStrings(fromFileAt: url.appendingPathComponent(filename)))
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

private extension NSDictionary {
    var allRecursiveKeys: Set<Substring> {
        var allKeys: Set<Substring> = []
        for (key, value) in self {
            if let key = key as? String {
                allKeys.insert(key[...])
            }

            if let value = value as? NSDictionary {
                allKeys.formUnion(value.allRecursiveKeys)
            }

            if let value = value as? NSArray {
                for element in value {
                    guard let element = element as? NSDictionary else { continue }
                    allKeys.formUnion(element.allRecursiveKeys)
                }
            }
        }

        return allKeys
    }
}
