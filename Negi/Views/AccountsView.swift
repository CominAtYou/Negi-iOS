import SwiftUI

struct AccountsView: View {
    @State private var settingsSession = ""
    @State private var searchQuery = ""
    @Binding var accounts: [Account]
    @State private var isPresentingAddSheet = false
    @State var newAccount = Account.emptyAccount
    @State private var selectedAccount: Account?
    @State var secondsToNextHop = 30
    @State private var isPresentingErrorAlert = false
    @State private var sidebarState = NavigationSplitViewVisibility.doubleColumn
    let saveAccounts: () -> Void
    
    var body: some View {
        NavigationSplitView(columnVisibility: $sidebarState, sidebar: {
            List(selection: $selectedAccount) {
                ForEach(searchResults) { account in
                    NavigationLink(value: account) {
                        AccountListEntry(account: account)
                    }
                }
                .onMove{ from, to in
                    accounts.move(fromOffsets: from, toOffset: to)
                    saveAccounts()
                }
            }
            .navigationTitle("Accounts")
            .toolbar {
                AccountsViewMenu(isPresentingAddSheet: $isPresentingAddSheet, selectedAccount: $selectedAccount)
            }
        }, detail: {
            if let selectedAccount {
                if (selectedAccount.token == "_settingsaccountd") {
                    SettingsView()
                }
                else {
                    AccountDetailsView(account: selectedAccount, secondsToNextHop: $secondsToNextHop)
                }
            }
            else {
                Text("No account selected")
                    .font(.title)
                    .opacity(0.4)
            }
        })
        .navigationSplitViewStyle(.balanced)
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
            return accounts.filter { $0.name.lowercased().contains(searchQuery.lowercased()) || $0.username.lowercased().contains(searchQuery.lowercased()) }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView(accounts: .constant(Account.sampleData), saveAccounts: {})
    }
}
