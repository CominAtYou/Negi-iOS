import Foundation
import LocalAuthentication

class LocalAuthenticationHandler {
    enum AuthenticationResult {
        case success
        case incompatiblePolicy
        case failed
    }
    
    static func authenticate() async -> AuthenticationResult {
        let context = LAContext()
        context.localizedCancelTitle = "Cancel"
        
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            NSLog(error?.localizedDescription ?? "Can't evaluate policy")
            return .incompatiblePolicy
        }
        
        let task = Task {
            do {
                try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Verify Your Identity")
                return AuthenticationResult.success
            }
            catch let error {
                print(error.localizedDescription)
                return AuthenticationResult.failed
            }
        }
        
        return await task.value
    }
}
