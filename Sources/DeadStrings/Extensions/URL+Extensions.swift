import Foundation

extension URL {
    func appendingOptionalPathComponent(_ pathComponent: String?) -> URL {
        if let pathComponent = pathComponent {
            return appendingPathComponent(pathComponent)
        } else {
            return self
        }
    }
}
