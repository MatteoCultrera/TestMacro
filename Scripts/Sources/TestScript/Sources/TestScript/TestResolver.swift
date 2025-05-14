import Foundation
import SwiftyScripty

// sourcery: AutoMockable
public protocol TestResolver: Actor {
    func hasTests(_ command: Command, packageName: String) -> Bool
    func isBuildPassed(_ command: Command, packageName: String) -> Bool
    func allTestPassed(_ command: Command, packageName: String) -> Bool
}

actor TestResolverImpl: TestResolver {
    @Injected(\.shell) var shell: Shell

    func hasTests(_ command: Command, packageName: String) -> Bool {
        let lines = command.errorOutput.split(separator: "\n").map { String($0) }
        if command.exitCode == .successExitCode {
            return true
        }

        if lines.contains(where: { $0.contains("error: no tests found") }) {
            shell.print(color: .yellow, text: "⚠️ No tests for this script")
            return false
        }

        return true
    }

    func isBuildPassed(_ command: Command, packageName: String) -> Bool {
        let lines = command.errorOutput.split(separator: "\n").map { String($0) }
        if command.exitCode == .successExitCode {
            return true
        }

        if lines.contains("error: fatalError") {
            shell.print(color: .red, text: "❌ Cannot build \(packageName).")
            return false
        }

        return true
    }

    func allTestPassed(_ command: Command, packageName: String) -> Bool {
        let lines = command.output.split(separator: "\n").map { String($0) }
        let recap = analyze(lines)

        recap.lines.forEach { shell.print(color: $1, text: $0) }

        if recap.passed {
            shell.print(color: .green, text: "✅ All tests of \(packageName) passed.")
        } else {
            shell.print(color: .red, text: "❌ \(packageName) tests failed.")
        }

        return recap.passed
    }
}

extension TestResolverImpl {
    func analyze(_ lines: [String]) -> TestRecap {
        let recap = TestRecap()
        for line in lines { analyze(line, in: recap) }
        return recap
    }

    func analyze(_ line: String, in recap: TestRecap) {
        if let outcome = Regex.Test.outcome(for: line) {
            recap.setTest(outcome.test, to: outcome.suite, outcome: outcome.recap)
        }
    }
}

private enum Regex {
    enum Test {
        static let started = /Test\ Case\ \'-\[(?<testSuite>[^ ]*)\ (?<testName>[^ ]+)\]\'\ started\./
        static let passed = /Test\ Case\ \'-\[(?<testSuite>[^ ]*)\ (?<testName>[^ ]+)\]\'\ passed \((?<seconds>[0-9.]+)\ seconds\)\./
        static let failed = /Test\ Case\ \'-\[(?<testSuite>[^ ]*)\ (?<testName>[^ ]+)\]\'\ failed \((?<seconds>[0-9.]+)\ seconds\)\./

        static func outcome(for line: String) -> Outcome? {
            if let match = try? started.wholeMatch(in: line) {
                Outcome(
                    suite: match.output.testSuite.isolated,
                    test: match.output.testName.string,
                    state: .started
                )
            } else if let match = try? passed.wholeMatch(in: line) {
                Outcome(
                    suite: match.output.testSuite.isolated,
                    test: match.output.testName.string,
                    state: .passed(time: match.output.seconds.string)
                )
            } else if let match = try? failed.wholeMatch(in: line) {
                Outcome(
                    suite: match.output.testSuite.isolated,
                    test: match.output.testName.string,
                    state: .failed(time: match.output.seconds.string)
                )
            } else { nil }
        }
    }

    struct Outcome {
        enum State {
            case started
            case passed(time: String)
            case failed(time: String)
        }

        let suite: String
        let test: String
        let state: State

        init(suite: String, test: String? = nil, state: State) {
            self.suite = String(suite)
            self.test = if let test { String(test) } else { "" }
            self.state = state
        }

        var recap: TestRecap.Outcome {
            switch state {
            case .started: .pending
            case .passed(let time): .passed(time: time)
            case .failed(let time): .failed(time: time)
            }
        }
    }
}

private extension Substring {
    var string: String { String(self) }

    var isolated: String {
        String(self.split(separator: ".").last ?? self)
    }
}
