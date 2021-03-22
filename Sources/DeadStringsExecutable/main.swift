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
    var write: Bool = false

    mutating func run() throws {
        guard let url = URL(string: path)
        else { throw RuntimeError.invalidPath(path: path) }

        let deadStringData = try extractDeadStrings(at: url)

        if !silent {
            print(deadStringData.descriptionByFile)
        }

        if write {
            try deleteDeadStrings(deadStringData.deadStrings, inFilesAt: url)
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
