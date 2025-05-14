import Foundation

public enum TestResult {
    case commandFailed
    case buildFailed
    case noTests
    case testFailed
    case testPassed
}

// sourcery: AutoMockable
public protocol TestSummary: Actor {
    func updateTest(testName: String, outcome: TestResult)
    func noTests() -> [String]
    func failedTests() -> [String]
    func failedBuilds() -> [String]
    func failedCommands() -> [String]
    func allTestPassed() -> Bool
}

actor TestSummaryImpl: TestSummary {
    // MARK: - Properties

    private var testOutcomes = AllTests()

    // MARK: - Test Summary Protocol

    func updateTest(testName: String, outcome: TestResult) {
        testOutcomes.addTest(testName, to: outcome)
    }

    func failedTests() -> [String] {
        testOutcomes.testsFailed.testNames
    }

    func noTests() -> [String] {
        testOutcomes.noTests.testNames
    }

    func failedBuilds() -> [String] {
        testOutcomes.buildsFailed.testNames
    }

    func failedCommands() -> [String] {
        testOutcomes.commandsFailed.testNames
    }

    func allTestPassed() -> Bool {
        !testOutcomes.hasFailures()
    }
}

// MARK: - Helper Structs

private extension TestSummaryImpl {
    private struct AllTests {
        var commandsFailed = TestOutcome()
        var buildsFailed = TestOutcome()
        var noTests = TestOutcome()
        var testsFailed = TestOutcome()
        var testsPassed = TestOutcome()

        mutating func addTest(_ name: String, to result: TestResult) {
            switch result {
            case .commandFailed:
                commandsFailed.addTest(name: name)
            case .noTests:
                noTests.addTest(name: name)
            case .buildFailed:
                buildsFailed.addTest(name: name)
            case .testFailed:
                testsFailed.addTest(name: name)
            case .testPassed:
                testsPassed.addTest(name: name)
            }
        }

        func hasFailures() -> Bool {
            if commandsFailed.testCount > 0 { return true }
            if buildsFailed.testCount > 0 { return true }
            if testsFailed.testCount > 0 { return true }
            return false
        }
    }

    private struct TestOutcome {
        var testCount = 0
        var testNames = [String]()

        mutating func addTest(name: String) {
            testCount+=1
            testNames.append(name)
        }
    }
}
