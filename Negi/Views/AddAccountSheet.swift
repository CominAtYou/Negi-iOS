import SwiftUI
import SwiftOTP

struct AddAccountSheet: View {
    @State var newAccount = Account.emptyAccount
    @State var isPresentingErrorAlert = false
    @Binding var isPresentingAddSheet: Bool
    @Binding var accounts: [Account]
    
    let saveAction: () -> Void
    
    var body: some View {
        NavigationStack {
            AddAccountForm(account: $newAccount)
                .navigationTitle("Add Account")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            isPresentingAddSheet = false
                            newAccount = Account.emptyAccount
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            let token = newAccount.token.filter { !$0.isWhitespace }
                            if (base32DecodeToData(token) != nil) {
                                isPresentingAddSheet = false
                                newAccount.token = token
                                accounts.append(newAccount)
                                newAccount = Account.emptyAccount
                                saveAction()
                            }
                            else {
                                isPresentingErrorAlert = true
                            }
                        }
                        .disabled(newAccount.name.isEmpty || newAccount.username.isEmpty || newAccount.token.isEmpty)
                    }
                }
                .alert(isPresented: $isPresentingErrorAlert) {
                    Alert(title: Text("Invalid Token"), message: Text("That token doesn't look right. Make sure you typed it correctly and try again."))
                }
        }
    }
}

struct AddAccountSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountSheet(isPresentingAddSheet: .constant(false), accounts: .constant(Account.sampleData), saveAction: {})
    }
}
