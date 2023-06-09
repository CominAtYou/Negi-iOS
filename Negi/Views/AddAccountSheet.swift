import SwiftUI
import SwiftOTP

struct AddAccountSheet: View {
    @State var newAccount = Account.emptyAccount
    @Binding var isPresentingAddSheet: Bool
    @EnvironmentObject var accountStore: AccountStore
    
    func submitAction() {
        let token = newAccount.token.filter { !$0.isWhitespace }
        isPresentingAddSheet = false
        newAccount.token = base32DecodeToData(token) != nil ? token : base32Encode(token.data(using: .utf8)!)
        accountStore.accounts.append(newAccount)
        newAccount = Account.emptyAccount
        
        accountStore.save()
    }
    
    var body: some View {
        NavigationStack {
            AddAccountForm(account: $newAccount, submitAction: submitAction)
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
                            submitAction()
                        }
                        .disabled(newAccount.name.isEmpty || newAccount.username.isEmpty || newAccount.token.isEmpty)
                    }
                }
        }
    }
}

struct AddAccountSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountSheet(isPresentingAddSheet: .constant(false))
    }
}
