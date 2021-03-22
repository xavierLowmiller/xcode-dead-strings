import Foundation

public func extractDeadStrings(at url: URL) throws -> DeadStringsData {
    let strings = try extractStrings(fromFilesAt: url)
    let localizedKeys = extractLocalizedKeys(fromFilesAt: url)

    let allLocalizedKeys: Set<Substring> = localizedKeys.reduce(into: []) {
        $0.formUnion($1.value)
    }

    return DeadStringsData(
        deadStrings: allLocalizedKeys.subtracting(strings),
        stringsByStringsFile: localizedKeys
    )
}
