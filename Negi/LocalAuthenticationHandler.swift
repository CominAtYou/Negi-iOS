import Foundation
import LocalAuthentication

class LocalAuthenticationHandler {
    enum AuthenticationStatus {
        case success
        case incompatiblePolicy
        case failed
    }
    
    static func authenticate() async -> AuthenticationStatus {
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
                return AuthenticationStatus.success
            }
            catch let error {
                print(error.localizedDescription)
                return AuthenticationStatus.failed
            }
        }
        
        return await task.value
    }
}
