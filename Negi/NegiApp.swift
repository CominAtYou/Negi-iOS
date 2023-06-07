import SwiftUI
import Foundation

@main
struct NegiApp: App {
    @StateObject var accountStore = AccountStore()
    @State var isAppLocked = UserDefaults.standard.bool(forKey: "AppLockEnabled")
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            if (isAppLocked) {
                LockedAppView(isAppLocked: $isAppLocked)
            }
            else {
                AccountsView(accounts: $accountStore.accounts) {
                    Task {
                        do {
                            try await accountStore.save()
                        }
                        catch {
                            fatalError(error.localizedDescription)
                        }
                    }
                }
                .task {
                    do {
                        try await accountStore.load()
                    }
                    catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
        .onChange(of: scenePhase, perform: { newPhase in
            if (newPhase == .background) {
                isAppLocked = true
            }
        })
    }
}
