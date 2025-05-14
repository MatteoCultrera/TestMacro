// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable all

import Foundation
import TestScript

public class TestResolverMock: TestResolver {

    public init() {}

    //MARK: - hasTests

    public var hasTestsPackageNameCallsCount = 0
    public var hasTestsPackageNameCalled: Bool {
        return hasTestsPackageNameCallsCount > 0
    }
    public var hasTestsPackageNameReceivedArguments: (command: Command, packageName: String)?
    public var hasTestsPackageNameReceivedInvocations: [(command: Command, packageName: String)] = []
    public var hasTestsPackageNameReturnValue: Bool!
    public var hasTestsPackageNameClosure: ((Command, String) -> Bool)?

    public func hasTests(_ command: Command, packageName: String) -> Bool {
        hasTestsPackageNameCallsCount += 1
        hasTestsPackageNameReceivedArguments = (command: command, packageName: packageName)
        hasTestsPackageNameReceivedInvocations.append((command: command, packageName: packageName))
        return hasTestsPackageNameClosure.map({ $0(command, packageName) }) ?? hasTestsPackageNameReturnValue
    }

    //MARK: - isBuildPassed

    public var isBuildPassedPackageNameCallsCount = 0
    public var isBuildPassedPackageNameCalled: Bool {
        return isBuildPassedPackageNameCallsCount > 0
    }
    public var isBuildPassedPackageNameReceivedArguments: (command: Command, packageName: String)?
    public var isBuildPassedPackageNameReceivedInvocations: [(command: Command, packageName: String)] = []
    public var isBuildPassedPackageNameReturnValue: Bool!
    public var isBuildPassedPackageNameClosure: ((Command, String) -> Bool)?

    public func isBuildPassed(_ command: Command, packageName: String) -> Bool {
        isBuildPassedPackageNameCallsCount += 1
        isBuildPassedPackageNameReceivedArguments = (command: command, packageName: packageName)
        isBuildPassedPackageNameReceivedInvocations.append((command: command, packageName: packageName))
        return isBuildPassedPackageNameClosure.map({ $0(command, packageName) }) ?? isBuildPassedPackageNameReturnValue
    }

    //MARK: - allTestPassed

    public var allTestPassedPackageNameCallsCount = 0
    public var allTestPassedPackageNameCalled: Bool {
        return allTestPassedPackageNameCallsCount > 0
    }
    public var allTestPassedPackageNameReceivedArguments: (command: Command, packageName: String)?
    public var allTestPassedPackageNameReceivedInvocations: [(command: Command, packageName: String)] = []
    public var allTestPassedPackageNameReturnValue: Bool!
    public var allTestPassedPackageNameClosure: ((Command, String) -> Bool)?

    public func allTestPassed(_ command: Command, packageName: String) -> Bool {
        allTestPassedPackageNameCallsCount += 1
        allTestPassedPackageNameReceivedArguments = (command: command, packageName: packageName)
        allTestPassedPackageNameReceivedInvocations.append((command: command, packageName: packageName))
        return allTestPassedPackageNameClosure.map({ $0(command, packageName) }) ?? allTestPassedPackageNameReturnValue
    }

}
