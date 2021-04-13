import Foundation

public struct DeadStringsData {
    let aliveStrings: Set<Substring>
    let localizedStringResults: [LocationStringResult]
    let deadStrings: Set<Substring>

    public init(url: URL, sourcePath: String? = nil, localizationPath: String? = nil) throws {
        aliveStrings = try extractStrings(fromFilesAt: url.appendingOptionalPathComponent(sourcePath))
        localizedStringResults = extractLocalizedKeys(fromFilesAt: url.appendingOptionalPathComponent(localizationPath))
        deadStrings = Set(localizedStringResults.map(\.key)).subtracting(aliveStrings)
    }

    public var descriptionByFile: String {
        guard !deadStrings.isEmpty else { return "No dead strings found!" }

        let stringsByStringsFile = Dictionary(
            grouping: localizedStringResults
                .filter { deadStrings.contains($0.key) })
            { $0.fileUrl }
            .mapValues { $0.map(\.key) }

        var returnValue = "Found dead strings:\n\n"
        for (url, contents) in stringsByStringsFile.sorted(by: { $0.key.path < $1.key.path }) {
            guard !contents.isEmpty else { continue }

            returnValue += "\(url.path):\n"
            returnValue += contents.sorted().joined(separator: "\n")
            returnValue += "\n\n"
        }

        return returnValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var stringsToDelete: [URL: [LocationStringResult]] {
        Dictionary(grouping:
            localizedStringResults
            .filter { deadStrings.contains($0.key) }) {
            $0.fileUrl
        }
    }

    public var xcodeWarnings: Set<String> {
        var warnings: [String] = []
        for (url, locations) in stringsToDelete {
            for location in locations {
                let warningText = "'\(location.key)' looks unused"
                warnings.append("\(url.path):\(location.lineNumber): warning: \(warningText)")
            }
        }

        return Set(warnings)
    }

    public func deleteDeadStrings() throws {
        let stringsToDelete = self.stringsToDelete
            .mapValues { $0.map(\.range).sorted(by: { $0.lowerBound > $1.lowerBound }) }

        for (url, rangesToDelete) in stringsToDelete {
            let data = FileManager.default.contents(atPath: url.path) ?? Data()
            var contents = String(decoding: data, as: UTF8.self)
            for range in rangesToDelete {
                contents.removeSubrange(range)
            }
            guard FileManager.default.isWritableFile(atPath: url.path) else { return }
            let fileUrl = URL(fileURLWithPath: url.path)
            try contents.data(using: .utf8)?.write(to: fileUrl)
        }
    }
}
