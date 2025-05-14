import Foundation
import SwiftyScripty

class TestRecap {
    var suites = [String: Suite]()

    func setTest(_ name: String, to suite: String, outcome: Outcome) {
        if let suite = suites[suite] {
            suite.setTest(name: name, outcome: outcome)
        } else {
            let newSuite = Suite()
            newSuite.setTest(name: name, outcome: outcome)
            suites[suite] = newSuite
        }
    }

    var lines: [(String, ANSIColors)] {
        suites.compactMap { $0.value.lines(for: $0.key) }.flatMap { $0 }
    }

    var passed: Bool {
        if suites.values.filter({ $0.failed }).isEmpty {
            true
        } else { false }
    }
}

extension TestRecap {
    typealias Suites = [Suite]

    class Suite {
        var outcome: TestRecap.Outcome {
            let (_, failed, pending) = analyzeOutcome()

            return if pending > 0 {
                .pending
            } else if failed > 0 {
                .failed(time: "")
            } else {
                .passed(time: "")
            }
        }

        var failed: Bool {
            switch outcome {
            case .pending, .failed: true
            case .passed: false
            }
        }

        var tests = [String: Test]()

        func setTest(name: String, outcome: Outcome = .pending) {
            tests[name] = Test(outcome: outcome)
        }

        func lines(for name: String) -> [(String, ANSIColors)]? {
            guard !tests.isEmpty else { return nil }

            var toRet = ["🏁 Test suite \(name) started...".formatted(.info, tabs: 1)]
            toRet.append(contentsOf: tests.map({ $0.value.line(for: $0.key) }))
            toRet.append(outcomeLine(for: name))
            return toRet
        }

        func analyzeOutcome() -> (passed: Int, failed: Int, pending: Int) {
            var passed = 0
            var failed = 0
            var pending = 0

            for test in tests.values {
                switch test.outcome {
                case .pending: pending += 1
                case .failed: failed += 1
                case .passed: passed += 1
                }
            }

            return (passed, failed, pending)
        }

        func outcomeLine(for name: String) -> (String, ANSIColors) {
            switch outcome {
            case .pending: "Test suite \(name) has crashed tests".formatted(.error, tabs: 1)
            case .passed: "Test suite \(name) passed.".formatted(.success, tabs: 1)
            case .failed: "Test suite \(name) failed.".formatted(.error, tabs: 1)
            }
        }
    }
}

extension TestRecap.Suite {
    struct Test {
        var outcome: TestRecap.Outcome

        func line(for name: String) -> (String, ANSIColors) {
            switch outcome {
            case .pending: "Test \(name) still pending".formatted(.warning, tabs: 2)
            case .passed(let time): "Test \(name) passed (⏱️ \(time) seconds)".formatted(.success, tabs: 2)
            case .failed(let time): "Test \(name) failed (⏱️ \(time) seconds)".formatted(.error, tabs: 2)
            }
        }
    }
}

extension TestRecap {
    enum Outcome {
        case pending
        case passed(time: String)
        case failed(time: String)

        var isPending: Bool {
            switch self {
            case .pending: true
            case .passed, .failed: false
            }
        }
    }
}

extension String {
    enum Format {
        case error
        case success
        case info
        case warning

        var emoji: String {
            switch self {
            case .error: "❌"
            case .success: "✅"
            case .info: ""
            case .warning: "⚠️"
            }
        }

        var color: ANSIColors {
            switch self {
            case .error: .red
            case .success: .green
            case .info, .warning: .yellow
            }
        }
    }

    static let tab = "  "

    func formatted(_ format: Format, tabs: Int = 0) -> (String, ANSIColors) {
        ("\(Self.tab.repeating(tabs))\(format.emoji) \(self)", format.color)
    }

    func repeating(_ times: Int) -> String {
        guard times > 0 else { return "" }

        var toRet = self
        for _ in 0..<times {
            toRet = toRet + self
        }

        return toRet
    }
}

extension [(String, ANSIColors)] {
    var topSpaced: [(String, ANSIColors)] {
        [("", .clear)] + self
    }
}
