// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable all
import SwiftyScripty

public struct TestResolverKey: InjectionKey {
    public static var liveValue: TestResolver { TestResolverImpl() }
}

extension InjectedValues {
    public var testResolver: TestResolver {
        get { return Self[TestResolverKey.self] }
    }
}
