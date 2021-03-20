import Foundation

func extractStrings(from string: String) -> Set<Substring> {
    let nsrange = NSRange(string.startIndex..<string.endIndex, in: string)
    let regex = try! NSRegularExpression(pattern: #"(?<=\")[\s\w]+(?=\")"#)

    var results: Set<Substring> = []
    regex.enumerateMatches(in: string, options: [], range: nsrange) { (match, _, _) in
        guard let match = match,
        let range = Range(match.range, in: string)
        else { return }

        results.insert(string[range])
    }

    return results
}
