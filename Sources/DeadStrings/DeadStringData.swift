import Foundation

public struct DeadStringsData {
    public var deadStrings: Set<Substring> = []
    public var stringsByStringsFile: [URL: Set<Substring>] = [:]

    public init(deadStrings: Set<Substring> = [], stringsByStringsFile: [URL : Set<Substring>] = [:]) {
        self.deadStrings = deadStrings
        self.stringsByStringsFile = stringsByStringsFile
    }

    public var descriptionByFile: String {
        guard !deadStrings.isEmpty else { return "No dead strings found!" }

        var returnValue = "Found dead strings:\n\n"
        for (url, contents) in stringsByStringsFile.sorted(by: { $0.key.path < $1.key.path }) {
            let deadStringsInFile = contents.intersection(deadStrings).sorted(by: <)
            guard !deadStringsInFile.isEmpty else { continue }

            returnValue += "\(url.path):\n"
            returnValue += deadStringsInFile.joined(separator: "\n")
            returnValue += "\n\n"
        }

        return returnValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
