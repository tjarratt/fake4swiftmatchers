
public protocol InvocationRecording {
    func invocations(for methodName: String) -> [[Any]]
}
