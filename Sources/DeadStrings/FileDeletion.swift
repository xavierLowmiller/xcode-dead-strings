import Foundation

func deleteDeadStrings(_ deadStrings: Set<Substring>, in file: String) -> String {
    var copy = file
    for stringToDelete in deadStrings {
        let pattern = #"(?<=;)\n[^;]*\""# + stringToDelete + #"\"\s=[^\n]*;"#
        copy = copy.replacingOccurrences(of: pattern, with: "", options: [.regularExpression])
    }
    return copy
}

func deleteDeadStrings(_ deadStrings: Set<Substring>, inFileAt url: URL) throws {
    let data = FileManager.default.contents(atPath: url.path) ?? Data()
    let withDeadStringsDeleted = deleteDeadStrings(deadStrings, in: String(decoding: data, as: UTF8.self))
    guard FileManager.default.isWritableFile(atPath: url.path) else { return }
    let fileUrl = URL(fileURLWithPath: url.path)
    try withDeadStringsDeleted.data(using: .utf8)?.write(to: fileUrl)
}

public func deleteDeadStrings(_ deadStrings: Set<Substring>, inFilesAt url: URL) throws {
    let enumerator = FileManager.default.enumerator(atPath: url.path)

    while let filename = enumerator?.nextObject() as? String {
        guard filename.hasSupportedSuffix else { continue }
        let fileUrl = url.appendingPathComponent(filename)

        try deleteDeadStrings(deadStrings, inFileAt: fileUrl)
    }
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
