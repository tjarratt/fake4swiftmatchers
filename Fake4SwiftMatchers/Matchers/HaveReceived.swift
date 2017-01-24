import Foundation
import Nimble

public struct HaveReceivedMatcher: Matcher {
    public typealias ValueType = InvocationRecording

    private let methodName: String

    fileprivate init(methodName: String) {
        self.methodName = methodName
    }

    public func matches(_ actualExpression: Expression<InvocationRecording>, failureMessage: FailureMessage) throws -> Bool {
        return try self._matches(actualExpression, failureMessage: failureMessage)
    }

    public func doesNotMatch(_ actualExpression: Expression<InvocationRecording>, failureMessage: FailureMessage) throws -> Bool {
        return try !self._matches(actualExpression, failureMessage: failureMessage)
    }

    public func with(_ arguments: Any...) -> HaveReceivedWithArgumentsMatcher {
        return HaveReceivedWithArgumentsMatcher(method: self.methodName,
                                                arguments: arguments)
    }

    private func _matches(_ actual: Expression<InvocationRecording>, failureMessage: FailureMessage) throws -> Bool {
        failureMessage.postfixMessage = "have received -\(self.methodName)"

        let realActual : InvocationRecording = try actual.evaluate()!

        return realActual.invocations(for: self.methodName).count > 0
    }
}

public struct HaveReceivedWithArgumentsMatcher: Matcher {
    public typealias ValueType = InvocationRecording

    private let methodName: String
    private let arguments: [Any]
    fileprivate init(method methodName: String, arguments: [Any]) {
        self.methodName = methodName
        self.arguments = arguments
    }

    public func matches(_ actualExpression: Expression<InvocationRecording>, failureMessage: FailureMessage) throws -> Bool {
        return try self._matches(actualExpression, failureMessage: failureMessage)
    }

    public func doesNotMatch(_ actualExpression: Expression<InvocationRecording>, failureMessage: FailureMessage) throws -> Bool {
        return try !self._matches(actualExpression, failureMessage: failureMessage)
    }

    fileprivate func _matches(_ actual: Expression<InvocationRecording>, failureMessage: FailureMessage) throws -> Bool {
        failureMessage.postfixMessage = "have received -\(self.methodName)"

        let realActual : InvocationRecording = try actual.evaluate()!

        guard realActual.invocations(for: methodName).count > 0 else {
            return false
        }

        for args in realActual.invocations(for: methodName) {
            let passed = args.enumerated().reduce(true) { passing, enumerated in
                if !passing {
                    return false
                }
                let (idx, argument) = enumerated
                let expectedArgument = self.arguments[idx]
                return passing && "\(argument)" == "\(expectedArgument)"
            }

            if passed {
                return true
            }
        }

        return false
    }
}

public func haveReceived(_ methodName: String) -> HaveReceivedMatcher {
    return HaveReceivedMatcher(methodName: methodName)
}
