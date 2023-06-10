//
//  CodeScannerSheet.swift
//  Negi
//
//  Created by William Martin on 6/9/23.
//

import SwiftUI
import CodeScanner

struct CodeScannerSheet: View {
    @Binding var isPresentingMainSheet: Bool
    @State private var isPresentingErrorAlert = false
    @Binding var isPresentingCodeScanner: Bool
    @Binding var accounts: [Account]
    let saveAccountsFunction: () -> Void
    
    var body: some View {
        NavigationView {
            CodeScannerView(codeTypes: [.qr], showViewfinder: true) { response in
                switch (response) {
                    case .success(let result):
                        guard let newAccount = OtpUriHandler.createAccountFromUri(uri: result.string) else {
                            isPresentingErrorAlert = true
                            return
                        }
                        accounts.append(newAccount)
                        saveAccountsFunction()
                    
                        isPresentingMainSheet = false
                        isPresentingCodeScanner = false
                    
                    case .failure(let error):
                        isPresentingErrorAlert = true
                        NSLog(error.localizedDescription)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresentingCodeScanner = false
                        isPresentingMainSheet = false
                    }
                }
            }
            .alert(isPresented: $isPresentingErrorAlert) {
                Alert(title: Text("Invalid QR Code"), message: Text("The scanned QR code is malformed or doesn't contain any account data. Try scanning it again, or enter the details of your account manually."), dismissButton: .default(Text("OK")) {
                    isPresentingCodeScanner = false
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
        CodeScannerSheet(isPresentingMainSheet: .constant(false), isPresentingCodeScanner: .constant(false), accounts: .constant(Account.sampleData), saveAccountsFunction: {})
    }
}
