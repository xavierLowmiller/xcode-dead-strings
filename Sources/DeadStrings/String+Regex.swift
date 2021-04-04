import Foundation

extension String {
    func matches(for pattern: String) -> [Substring] {
        let nsrange = NSRange(startIndex..<endIndex, in: self)
        let regex = try! NSRegularExpression(pattern: pattern, options: [.allowCommentsAndWhitespace])
        var results: [Substring] = []
        regex.enumerateMatches(in: self, options: [], range: nsrange) { (match, _, _) in
            guard let match = match,
                  let range = Range(match.range, in: self)
            else { return }

            results.append(self[range])
        }
        return results
    }
}
