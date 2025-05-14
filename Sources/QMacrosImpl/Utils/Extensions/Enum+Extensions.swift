import SwiftSyntax

extension EnumDeclSyntax {
    var cases: [EnumCaseDeclSyntax] {
        memberBlock.members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
    }

    var elements: [EnumCaseElementSyntax] {
        cases.flatMap { $0.elements }
    }
}

struct Parameter {
    let firstLabel: String?
    let secondLabel: String?
    let type: String

    init(firstLabel: String?, secondLabel: String?, type: String) {
        self.firstLabel = if firstLabel == "_" { nil } else { firstLabel }
        self.secondLabel = secondLabel
        self.type = type
    }

    public var description: String {
        var toRet = ""
        if let firstLabel { toRet.append(firstLabel.capitalized) }
        if let secondLabel { toRet.append(secondLabel.capitalized) }
        toRet.append(type.capitalized)
        return toRet
    }
}

extension EnumCaseElementSyntax {
    var parameters: [Parameter] {
        guard let parameterClause else { return  [] }

        return parameterClause.parameters.map { value in
            Parameter(
                firstLabel: value.firstName?.text,
                secondLabel: value.secondName?.text,
                type: value.type.description
            )
        }
    }
}
