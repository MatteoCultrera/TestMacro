import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import QMacrosModels

/// Implementation of the `@stateless` macro.
///
/// This macro must be applied to an `enum`. It analyzes the enum cases and generates a nested
/// enum named `Stateless`, which simplifies the original cases according to the selected
/// `StatelessBehaviour`. The nested enum conforms to `CaseIterable`.
///
/// Additionally, a static property `statelessElements` is added to expose all values
/// of the generated `Stateless` enum.
///
/// Example input:
///
///     @stateless(behaviour: .includeLabels)
///     enum Example {
///         case one(label: String), two
///         case one(label2: Bool)
///     }
///
/// Expanded output:
///
///     enum Example {
///         case one(label: String), two
///         case one(label2: Bool)
///
///         enum Stateless: CaseIterable {
///             case oneLabel2Bool
///             case oneLabelString
///             case two
///         }
///
///         static var statelessElements: [Stateless] {
///             return Stateless.allCases
///         }
///     }
public struct StatelessMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw MacroExpansionErrorMessage("Stateless is only appliable to enums")
        }

        var toRet = ["\(Keyword.enum) Stateless: CaseIterable {"]

        let elements = switch getParameter(from: node) {
        case .noChange: enumDecl.elements.map { "\(Keyword.case) \($0.name) "}
        case .trimDuplicates: enumDecl.elements.map { "\(Keyword.case) \($0.name) "}.withoutDuplicates
        case .includeLabels:
            enumDecl.elements.map { "\(Keyword.case) \($0.name)\($0.parameters.map { $0.description }.joined())"}
        }

        toRet.append(contentsOf: elements.sorted())
        toRet.append("}")
        return [
            DeclSyntax(stringLiteral: toRet.joined(separator: "\n")),
            DeclSyntax(stringLiteral: "static var statelessElements: [Stateless] { return Stateless.allCases }")
        ]
    }

    private static func getParameter(from node: AttributeSyntax) -> StatelessBehaviour {
        if case let .argumentList(argumentList) = node.arguments, let argument = argumentList.first {
            switch argument.expression.description {
            case ".noChange": .noChange
            case ".includeLabels": .includeLabels
            case ".trimDuplicates": .trimDuplicates
            default: .noChange
            }
        } else { .noChange }
    }
}

@main
struct QMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StatelessMacro.self
    ]
}
