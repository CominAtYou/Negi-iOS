import SwiftUI

struct AccountsViewMenu: View {
    @State var isPresentingErrorAlert = false
    @Binding var isPresentingMainSheet: Bool
    @Binding var currentSheetView: SheetViewState
    @Binding var selectedAccount: Account?
    
    var body: some View {
        Menu {
            Menu {
                Button {
                    Task {
                        if await CameraPermissions.requestPermissions() == .authorized {
                            currentSheetView = .scanner
                            isPresentingMainSheet = true
                        }
                        else {
                            isPresentingErrorAlert = true
                        }
                    }
                } label: {
                    Label("Scan QR Code", systemImage: "qrcode.viewfinder")
                }
                Button {
                    currentSheetView = .form
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
        .alert(isPresented: $isPresentingErrorAlert) {
            Alert(
                title: Text("Can't Access Camera"),
                message: Text("Negi doesn't have permission to access the camera. You can enable the camera permission in Settings in order to scan a QR code."),
                primaryButton: .default(Text("Open Settings")) {
                    let url = URL(string: UIApplication.openSettingsURLString)!
                    UIApplication.shared.open(url, options: [:])
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct AccountsViewMenu_Previews: PreviewProvider {
    static var previews: some View {
        AccountsViewMenu(isPresentingMainSheet: .constant(false), currentSheetView: .constant(.form), selectedAccount: .constant(nil))
    }
}
