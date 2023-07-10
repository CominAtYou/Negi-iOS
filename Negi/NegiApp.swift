import SwiftUI
import Foundation

@main
struct NegiApp: App {
    
    @StateObject var accountStore = AccountStore()
    @State var isAppLocked = UserDefaults.standard.bool(forKey: "AppLockEnabled")
    @State var hasAttemptedAutomaticUnlock = false
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            if (isAppLocked) {
                LockedAppView(isAppLocked: $isAppLocked)
            }
            else {
                AccountsView()
                .environmentObject(accountStore)
                .task {
                    do {
                        try await accountStore.load()
                    }
                    catch {
                        // TODO: Fall back to a backup
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
        .onChange(of: scenePhase, perform: { newPhase in
            let isAppLockEnabled = UserDefaults.standard.bool(forKey: "AppLockEnabled")
            
            if (newPhase == .background && isAppLockEnabled) {
                isAppLocked = true
                hasAttemptedAutomaticUnlock = false
            }
            
            if (newPhase == .active && !hasAttemptedAutomaticUnlock && isAppLockEnabled) {
                Task {
                    if await LocalAuthenticationHandler.authenticate() == .success {
                        isAppLocked = false
                    }
                    
                    hasAttemptedAutomaticUnlock = true
                }
            }
        })
    }
}
