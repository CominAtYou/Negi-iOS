import SwiftUI
import CodeScanner

struct AccountsView: View {
    @State private var searchQuery = ""
    @EnvironmentObject var accountStore: AccountStore
    @State private var isPresentingMainSheet = false
    @State private var selectedAccount: Account?
    @State var secondsToNextHop = 30
    @State var isPresentingErrorAlert = false
    @State var currentSheetView = SheetViewState.scanner
    @State var newAccount = Account.emptyAccount
    @State private var sidebarState = NavigationSplitViewVisibility.doubleColumn


    var body: some View {
        NavigationSplitView(columnVisibility: $sidebarState, sidebar: {
            List(selection: $selectedAccount) {
                ForEach(searchResults) { account in
                    NavigationLink(value: account) {
                        AccountListEntry(account: account)
                    }
                }
                .onMove{ from, to in
                    accountStore.accounts.move(fromOffsets: from, toOffset: to)
                    accountStore.save()
                }
            }
            .navigationTitle("Accounts")
            .toolbar {
                AccountsViewMenu(isPresentingMainSheet: $isPresentingMainSheet, currentSheetView: $currentSheetView, selectedAccount: $selectedAccount)
            }
        }, detail: {
            if let selectedAccount {
                if (selectedAccount.token == "_settingsaccountd") {
                    SettingsView()
                }
                else {
                    AccountDetailsView(account: selectedAccount, secondsToNextHop: $secondsToNextHop, selectedAccount: $selectedAccount)
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
            if (currentSheetView == .scanner) {
                CodeScannerSheet(isPresentingMainSheet: $isPresentingMainSheet)
            }
            else {
                AddAccountSheet(isPresentingAddSheet: $isPresentingMainSheet)
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
            return accountStore.accounts
        }
        else {
            return accountStore.accounts.filter { $0.name.lowercased().contains(searchQuery.lowercased()) || $0.username.lowercased().contains(searchQuery.lowercased()) }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
            .environmentObject({ () -> AccountStore in
                let store = AccountStore()
                store.accounts = Account.sampleData
                return store
            }())
    }
}
