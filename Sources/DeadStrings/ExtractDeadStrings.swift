import Foundation

public func extractDeadStrings(at url: URL,
							   sourcePath: String,
							   localizationPath: String) throws -> DeadStringsData {
	let strings = try extractStrings(fromFilesAt: url.appendingPathComponent(sourcePath))
	let localizedKeys = extractLocalizedKeys(fromFilesAt: url.appendingPathComponent(localizationPath))

    let allLocalizedKeys: Set<Substring> = localizedKeys.reduce(into: []) {
        $0.formUnion($1.value)
    }

    return DeadStringsData(
        deadStrings: allLocalizedKeys.subtracting(strings),
        stringsByStringsFile: localizedKeys
    )
}
