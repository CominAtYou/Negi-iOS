import SwiftUI

struct AccountsViewMenu: View {
    @Binding var isPresentingMainSheet: Bool
    @Binding var isPresentingCodeScanner: Bool
    @Binding var selectedAccount: Account?
    
    var body: some View {
        Menu {
            Menu {
                Button {
                    isPresentingCodeScanner = true
                    isPresentingMainSheet = true
                } label: {
                    Label("Scan QR Code", systemImage: "qrcode.viewfinder")
                }
                Button {
                    isPresentingMainSheet = true
                } label: {
                    Label("Add Manually", systemImage: "rectangle.and.pencil.and.ellipsis")
                }
            } label: {
                Label("Add Account", systemImage: "plus")
            }
            Button {
                // This is stupid. This was the easiest way to get NavigationSplitView to cooporate though
                // "_settngsaccountd" will get encoded as base32 if someone tries to manually add an account with it as a token, so no account can present the settings sheet
                selectedAccount = Account(name: "", username: "", token: "_settingsaccountd")
            } label: {
                Label("Settings", systemImage: "gear")
            }
        } label: {
            Label("Options", systemImage: "ellipsis.circle")
        }
    }
}

struct AccountsViewMenu_Previews: PreviewProvider {
    static var previews: some View {
        AccountsViewMenu(isPresentingMainSheet: .constant(false), isPresentingCodeScanner: .constant(false), selectedAccount: .constant(nil))
    }
}
