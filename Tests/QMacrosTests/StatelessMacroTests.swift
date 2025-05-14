import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import QMacrosImpl

let testMacros: [String: Macro.Type] = ["stateless": StatelessMacro.self]

final class StatelessMacroTests: XCTestCase {
    func test_givenEnumWithValues_thenGeneratesCorrectSource() throws {
        assertMacroExpansion(
            #"""
            @stateless
            enum Test {
                case first(label: String), second
                case third
                case fourth(first: Bool, second: Int)

                var myBad: String { "Error" }
            }
            """#,
            expandedSource: #"""
            enum Test {
                case first(label: String), second
                case third
                case fourth(first: Bool, second: Int)

                var myBad: String { "Error" }

                enum Stateless: CaseIterable {
                    case first
                    case fourth
                    case second
                    case third
                }

                static var statelessElements: [Stateless] {
                    return Stateless.allCases
                }
            }
            """#,
            macros: testMacros
        )
    }

    func test_givenEnumWithValues_andTrimDuplicates_thenGeneratesCorrectSource() throws {
        assertMacroExpansion(
            #"""
            @stateless(behaviour: .trimDuplicates)
            enum Test {
                case first(label: String), second
                case third
                case first(some: Bool)
                case fourth(_ first: Bool, second: Int)
            }
            """#,
            expandedSource: #"""
            enum Test {
                case first(label: String), second
                case third
                case first(some: Bool)
                case fourth(_ first: Bool, second: Int)

                enum Stateless: CaseIterable {
                    case first
                    case fourth
                    case second
                    case third
                }

                static var statelessElements: [Stateless] {
                    return Stateless.allCases
                }
            }
            """#,
            macros: testMacros
        )
    }

    func test_givenEnumWithValues_andIncludeLabels_thenGeneratesCorrectSource() throws {
        assertMacroExpansion(
            #"""
            @stateless(behaviour: .includeLabels)
            enum Test {
                case first(label: String, other: Bool), second
                case third
                case first(labelOther: Bool)
                case fourth(first: Bool, second: Int)
            }
            """#,
            expandedSource: #"""
            enum Test {
                case first(label: String, other: Bool), second
                case third
                case first(labelOther: Bool)
                case fourth(first: Bool, second: Int)

                enum Stateless: CaseIterable {
                    case firstLabelOtherBool
                    case firstLabelStringOtherBool
                    case fourthFirstBoolSecondInt
                    case second
                    case third
                }

                static var statelessElements: [Stateless] {
                    return Stateless.allCases
                }
            }
            """#,
            macros: testMacros
        )
    }
}
