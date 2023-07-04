import SwiftUI
import CodeScanner

struct AccountsView: View {
    @State private var searchQuery = ""
    @Binding var accounts: [Account]
    @State private var isPresentingMainSheet = false
    @State private var selectedAccount: Account?
    @State var secondsToNextHop = 30
    @State var isPresentingErrorAlert = false
    @State var isPresentingCodeScanner = false
    @State private var sidebarState = NavigationSplitViewVisibility.doubleColumn
    let saveAccountsFunction: () -> Void
    
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
                    saveAccountsFunction()
                }
            }
            .navigationTitle("Accounts")
            .toolbar {
                AccountsViewMenu(isPresentingMainSheet: $isPresentingMainSheet, isPresentingCodeScanner: $isPresentingCodeScanner, selectedAccount: $selectedAccount)
            }
        }, detail: {
            if let selectedAccount {
                if (selectedAccount.token == "_settingsaccountd") {
                    SettingsView(accounts: $accounts)
                }
                else {
                    AccountDetailsView(account: selectedAccount, secondsToNextHop: $secondsToNextHop, selectedAccount: $selectedAccount, accounts: $accounts, saveAction: saveAccountsFunction)
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
        .sheet(isPresented: $isPresentingMainSheet) {
            if (isPresentingCodeScanner) {
                // TODO: Display error if camera permissions aren't enabled
                CodeScannerSheet(isPresentingMainSheet: $isPresentingMainSheet, isPresentingCodeScanner: $isPresentingCodeScanner, accounts: $accounts, saveAccountsFunction: saveAccountsFunction)
            }
            else {
                AddAccountSheet(isPresentingAddSheet: $isPresentingMainSheet, accounts: $accounts, saveAction: saveAccountsFunction)
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
        AccountsView(accounts: .constant(Account.sampleData), saveAccountsFunction: {})
    }
}
