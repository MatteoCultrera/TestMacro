import QMacros

@stateless
enum Test {
    case first(label: String), second
    case third
    case fourth(_ first: Bool, second: Int)

    var myBad: String { "Error" }
}

@stateless(behaviour: .trimDuplicates)
enum Test2 {
    case first(label: String), second
    case third
    case first(some: Bool)
    case fourth(_ first: Bool, second: Int)

    var myBad: String { "Error" }
}

@stateless(behaviour: .includeLabels)
enum Test3 {
    case first(label: String, other: Bool), second
    case third
    case first(labelOther: Bool)
    case fourth(first: Bool, second: Int)

    var myBad: String { "Error" }
}

