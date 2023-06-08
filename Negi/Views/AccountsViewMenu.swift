import SwiftUI

struct AccountsViewMenu: View {
    @Binding var isPresentingAddSheet: Bool
    
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
                NSLog("todo")
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
        AccountsViewMenu(isPresentingAddSheet: .constant(false))
    }
}
