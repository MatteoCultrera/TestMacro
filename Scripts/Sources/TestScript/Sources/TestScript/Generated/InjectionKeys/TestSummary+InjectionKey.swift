// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable all
import SwiftyScripty

public struct TestSummaryKey: InjectionKey {
    public static var liveValue: TestSummary { TestSummaryImpl() }
}

extension InjectedValues {
    public var testSummary: TestSummary {
        get { return Self[TestSummaryKey.self] }
    }
}
