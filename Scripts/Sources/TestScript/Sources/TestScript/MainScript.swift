import Foundation
import SwiftyScripty

@main
public struct TestScripts {
    @Injected(\.shell) var shell
    @Injected(\.testResolver) var testResolver
    @Injected(\.testSummary) var testSummary

    public static func main() async {
        await TestScripts().main(args: CommandLine.arguments)
    }

    public func main(args: [String] = []) async {
        let verbose = args.contains("verbose")

        let output = launchTests(verbose: verbose)
        let outcome = await checkTestOutput(output, packageName: "QMacros", verbose: verbose)
        await testSummary.updateTest(testName: "QMacros", outcome: outcome)

        // Print recap and return
        let noTests = await testSummary.noTests()
        if !noTests.isEmpty {
            shell.print(color: .yellow, text: "\nThe following scripts have no tests:")
            noTests.forEach { shell.print(color: .yellow, text: $0.bulletedItem) }
        }
        let failedCommands = await testSummary.failedCommands()
        if !failedCommands.isEmpty {
            shell.print(color: .red, text: "\nThe following scripts has failed commands:")
            failedCommands.forEach { shell.print(color: .red, text: $0.bulletedItem) }
        }
        let failedBuilds = await testSummary.failedBuilds()
        if !failedBuilds.isEmpty {
            shell.print(color: .red, text: "\nThe following scripts has failed builds:")
            failedBuilds.forEach { shell.print(color: .red, text: $0.bulletedItem) }
        }
        let failedTests = await testSummary.failedTests()
        if !failedTests.isEmpty {
            shell.print(color: .red, text: "\nThe following scripts has failed tests:")
            failedTests.forEach { shell.print(color: .red, text: $0.bulletedItem) }
        }

        guard await testSummary.allTestPassed() else {
            shell.exit(with: .errorExitCode)
            return
        }

        return
    }

    func launchTests(verbose: Bool) -> Command? {
        shell.print(color: .green, text: "QMacros".startingTests)
        return shell.zshWithExitCode(command: "swift test")
    }

    func checkTestOutput(_ command: Command?, packageName: String, verbose: Bool) async -> TestResult {
        defer {
            if verbose, let command {
                shell.print(color: .yellow, text: "\nVerbose Output---\n")
                shell.print(color: .green, text: command.output)
                shell.print(color: .yellow, text: "\nVerbose Output End---\n")
            }
        }

        shell.print(color: .green, text: packageName.testOutcome)
        guard let command else {
            shell.print(color: .red, text: packageName.commandFailed)
            return .commandFailed
        }

        guard await testResolver.isBuildPassed(command, packageName: packageName) else {
            return .buildFailed
        }

        guard await testResolver.hasTests(command, packageName: packageName) else {
            return .noTests
        }

        guard await testResolver.allTestPassed(command, packageName: packageName) else {
            return .testFailed
        }

        return .testPassed
    }
}

private extension String {
    var testOutcome: String {
        "\nTest Outcome of \(self)"
    }

    var startingTests: String {
        "Starting tests of \(self)..."
    }

    var commandFailed: String {
        "Failed to run command for \(self)"
    }

    var buildFailed: String {
        "Failed to build \(self)"
    }

    var testFailed: String {
        "Script \(self) has failing tests"
    }

    var bulletedItem: String {
        "   • \(self)"
    }
}

private extension Int {
    static let chunkSize = 5
}

extension Shell {
    func newLine() { self.print(color: .clear, text: "\n") }
}
