import QMacrosModels

/// A macro that generates a nested `Stateless` enum inside the annotated enum, containing
/// simplified, case-only representations of the original cases.
///
/// **Must be applied to an Enum**
///
/// The generated `Stateless` enum conforms to `CaseIterable`, and a static property
/// `statelessElements` is added for easy access to its cases.
///
/// The behavior of how enum cases are transformed can be customized via the `behaviour` argument:
///
/// - `.noChange`: Keeps only the original case names.
/// - `.trimDuplicates`: Same as `.noChange` but removes possible duplicated cases.
/// - `.includeLabels`: Includes labels and types from associated values for uniqueness.
///
/// For example:
///
///     @stateless(behaviour: .includeLabels)
///     enum Test {
///         case a(label: Int), b
///         case a(label: Bool)
///     }
///
/// Will expand to:
///
///     enum Test {
///         ...
///         enum Stateless: CaseIterable {
///             case aLabelBool
///             case aLabelInt
///             case b
///         }
///
///         static var statelessElements: [Stateless] {
///             return Stateless.allCases
///         }
///     }
@attached(member, names: arbitrary)
public macro stateless(behaviour: StatelessBehaviour = .noChange) = #externalMacro(module: "QMacrosImpl", type: "StatelessMacro")

