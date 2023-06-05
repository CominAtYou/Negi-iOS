import SwiftUI

struct AccountsView: View {
    @State private var searchQuery = ""
    @Binding var accounts: [Account]
    @State private var isPresentingAddSheet = false
    @State var newAccount = Account.emptyAccount
    @State var secondsToNextHop = 30
    @State var isPresentingErrorAlert = false
    let saveAccounts: () -> Void
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults) { account in
                    NavigationLink(destination: AccountDetailsView(account: account, secondsToNextHop: $secondsToNextHop)) {
                        AccountListEntry(account: account)
                    }
                }
                .onMove{ from, to in
                    accounts.move(fromOffsets: from, toOffset: to)
                }
            }
            .navigationTitle("Accounts")
            .toolbar {
                Button(action: {
                    isPresentingAddSheet = true
                }) {
                    Image(systemName: "plus")
                }
            }
            .accessibilityLabel("Add account")
        }
        .searchable(text: $searchQuery)
        .sheet(isPresented: $isPresentingAddSheet) {
            AddAccountSheet(isPresentingAddSheet: $isPresentingAddSheet, accounts: $accounts) {
                saveAccounts()
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                let secondsToMinute = Calendar.current.component(.second, from: Date())
                secondsToNextHop = 30 - secondsToMinute % 30
            })
        }
    }
    
    var searchResults: [Account] {
        if searchQuery.isEmpty {
            return accounts
        }
        else {
            return accounts.filter { $0.name.contains(searchQuery.lowercased()) || $0.username.contains(searchQuery.lowercased()) }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView(accounts: .constant(Account.sampleData), saveAccounts: {})
    }
}
