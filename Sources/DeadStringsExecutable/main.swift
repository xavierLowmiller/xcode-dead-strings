import ArgumentParser
import Foundation
import DeadStrings

struct DeadStrings: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Finds unused entries in .strings files")

    @Argument(help: "The root path of the iOS directory")
    var path: String = "."

    @Flag(help: "Should output be silenced?")
    var silent: Bool = false

    @Flag(help: "Delete dead strings from .strings files automatically")
    var delete: Bool = false

    @Option(help: "Path containing the source files to be searched")
    var sourcePath: String?

    @Option(help: "Path containing the localization files to be searched")
    var localizationPath: String?

    mutating func run() throws {
        guard let url = URL(string: path)
        else { throw RuntimeError.invalidPath(path: path) }

        let data = try DeadStringsData(url: url, sourcePath: sourcePath, localizationPath: localizationPath)

        if !silent {
            print(data.descriptionByFile)
        }

        if delete {
            try data.deleteDeadStrings()
        }
    }
}

struct RuntimeError: Error, CustomStringConvertible {
    var description: String

    init(_ description: String) {
        self.description = description
    }

    static func invalidPath(path: String) -> RuntimeError {
        RuntimeError("Invalid path: \(path)")
    }
}

DeadStrings.main()
