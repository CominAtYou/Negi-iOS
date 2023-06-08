import SwiftUI

struct AccountsViewMenu: View {
    @Binding var isPresentingAddSheet: Bool
    @Binding var selectedAccount: Account?
    
    var body: some View {
        Menu {
            Menu {
                Button {
                    NSLog("todo")
                } label: {
                    Label("Scan QR code", systemImage: "qrcode.viewfinder")
                }
                Button {
                    isPresentingAddSheet = true
                } label: {
                    Label("Add manually", systemImage: "rectangle.and.pencil.and.ellipsis")
                }
            } label: {
                Label("Add account", systemImage: "plus")
            }
            Button {
                // This is stupid. This was the easiest way to get NavigationSplitView to cooporate though
                // "_settngsaccountd" isn't valid base32, so the add account sheet will prevent accounts being made with it as a token
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
        AccountsViewMenu(isPresentingAddSheet: .constant(false), selectedAccount: .constant(nil))
    }
}
