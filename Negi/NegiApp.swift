import SwiftUI

@main
struct NegiApp: App {
    @StateObject var accountStore = AccountStore()
    
    var body: some Scene {
        WindowGroup {
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
}
