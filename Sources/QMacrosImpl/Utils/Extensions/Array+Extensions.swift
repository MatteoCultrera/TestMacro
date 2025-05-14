import Foundation

extension Array where Element: Hashable {
    var withoutDuplicates: [Element] { Array(Set(self)) }
}
