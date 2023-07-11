import SwiftUI
import CodeScanner

struct CodeScannerSheet: View {
    @Binding var isPresentingMainSheet: Bool
    @State private var isPresentingErrorAlert = false
    @EnvironmentObject var accountStore: AccountStore

    var body: some View {
        NavigationView {
            CodeScannerView(codeTypes: [.qr], showViewfinder: true) { response in
                switch (response) {
                    case .success(let result):
                        guard let newAccount = OtpUriHandler.createAccountFromUri(uri: result.string) else {
                            isPresentingErrorAlert = true
                            return
                        }
                    accountStore.accounts.append(newAccount)
                    accountStore.save()

                        isPresentingMainSheet = false

                    case .failure(let error):
                        isPresentingErrorAlert = true
                        NSLog(error.localizedDescription)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresentingMainSheet = false
                    }
                }
            }
            .alert(isPresented: $isPresentingErrorAlert) {
                Alert(title: Text("Invalid QR Code"), message: Text("The scanned QR code is malformed or doesn't contain any account data. Try scanning it again, or enter the details of your account manually."), dismissButton: .default(Text("OK")) {
                    isPresentingMainSheet = false
                })
            }
            .navigationTitle("Add Account")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CodeScannerSheet_Previews: PreviewProvider {
    static var previews: some View {
        CodeScannerSheet(isPresentingMainSheet: .constant(false))
    }
}
