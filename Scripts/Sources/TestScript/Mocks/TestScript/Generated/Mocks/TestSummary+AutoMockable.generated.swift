// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable all

import Foundation
import TestScript

public class TestSummaryMock: TestSummary {

    public init() {}

    //MARK: - updateTest

    public var updateTestTestNameOutcomeCallsCount = 0
    public var updateTestTestNameOutcomeCalled: Bool {
        return updateTestTestNameOutcomeCallsCount > 0
    }
    public var updateTestTestNameOutcomeReceivedArguments: (testName: String, outcome: TestResult)?
    public var updateTestTestNameOutcomeReceivedInvocations: [(testName: String, outcome: TestResult)] = []
    public var updateTestTestNameOutcomeClosure: ((String, TestResult) -> Void)?

    public func updateTest(testName: String, outcome: TestResult) {
        updateTestTestNameOutcomeCallsCount += 1
        updateTestTestNameOutcomeReceivedArguments = (testName: testName, outcome: outcome)
        updateTestTestNameOutcomeReceivedInvocations.append((testName: testName, outcome: outcome))
        updateTestTestNameOutcomeClosure?(testName, outcome)
    }

    //MARK: - noTests

    public var noTestsCallsCount = 0
    public var noTestsCalled: Bool {
        return noTestsCallsCount > 0
    }
    public var noTestsReturnValue: [String]!
    public var noTestsClosure: (() -> [String])?

    public func noTests() -> [String] {
        noTestsCallsCount += 1
        return noTestsClosure.map({ $0() }) ?? noTestsReturnValue
    }

    //MARK: - failedTests

    public var failedTestsCallsCount = 0
    public var failedTestsCalled: Bool {
        return failedTestsCallsCount > 0
    }
    public var failedTestsReturnValue: [String]!
    public var failedTestsClosure: (() -> [String])?

    public func failedTests() -> [String] {
        failedTestsCallsCount += 1
        return failedTestsClosure.map({ $0() }) ?? failedTestsReturnValue
    }

    //MARK: - failedBuilds

    public var failedBuildsCallsCount = 0
    public var failedBuildsCalled: Bool {
        return failedBuildsCallsCount > 0
    }
    public var failedBuildsReturnValue: [String]!
    public var failedBuildsClosure: (() -> [String])?

    public func failedBuilds() -> [String] {
        failedBuildsCallsCount += 1
        return failedBuildsClosure.map({ $0() }) ?? failedBuildsReturnValue
    }

    //MARK: - failedCommands

    public var failedCommandsCallsCount = 0
    public var failedCommandsCalled: Bool {
        return failedCommandsCallsCount > 0
    }
    public var failedCommandsReturnValue: [String]!
    public var failedCommandsClosure: (() -> [String])?

    public func failedCommands() -> [String] {
        failedCommandsCallsCount += 1
        return failedCommandsClosure.map({ $0() }) ?? failedCommandsReturnValue
    }

    //MARK: - allTestPassed

    public var allTestPassedCallsCount = 0
    public var allTestPassedCalled: Bool {
        return allTestPassedCallsCount > 0
    }
    public var allTestPassedReturnValue: Bool!
    public var allTestPassedClosure: (() -> Bool)?

    public func allTestPassed() -> Bool {
        allTestPassedCallsCount += 1
        return allTestPassedClosure.map({ $0() }) ?? allTestPassedReturnValue
    }

}
