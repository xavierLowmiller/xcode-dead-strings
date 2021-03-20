import Foundation

func extractDeadStrings(at url: URL) -> Set<Substring> {
    let strings = extractStrings(fromFilesAt: url)
    let localizedKeys = extractLocalizedKeys(fromFilesAt: url)

    return localizedKeys.subtracting(strings)
}
