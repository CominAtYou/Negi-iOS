import SwiftUI
import SwiftOTP

struct AddAccountSheet: View {
    @State var newAccount = Account.emptyAccount
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
                            isPresentingAddSheet = false
                            newAccount.token = base32DecodeToData(token) != nil ? token : base32Encode(token.data(using: .utf8)!)
                            accounts.append(newAccount)
                            newAccount = Account.emptyAccount
                            saveAction()
                        }
                        .disabled(newAccount.name.isEmpty || newAccount.username.isEmpty || newAccount.token.isEmpty)
                    }
                }
        }
    }
}

struct AddAccountSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountSheet(isPresentingAddSheet: .constant(false), accounts: .constant(Account.sampleData), saveAction: {})
    }
}
