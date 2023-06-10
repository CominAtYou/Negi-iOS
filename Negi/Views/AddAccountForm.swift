import SwiftUI

struct AddAccountForm: View {
    @Binding var account: Account
    enum Field: Hashable {
        case accountName
        case username
        case token
    }
    @FocusState private var focusedField: Field?
    
    let submitAction: () -> Void
    
    var body: some View {
        Form {
            Section(header: Text("Account info")) {
                LabeledContent {
                    TextField("Slack", text: $account.name)
                        .focused($focusedField, equals: .accountName)
                        .multilineTextAlignment(.trailing)
                } label: {
                    Text("Account Name")
                }
                
                LabeledContent {
                    TextField("john.appleseed", text: $account.username)
                        .autocorrectionDisabled(true)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .multilineTextAlignment(.trailing)
                        .focused($focusedField, equals: .username)
                } label: {
                    Text("Username")
                }
                
                LabeledContent {
                    TextField("token", text: $account.token)
                        .autocorrectionDisabled(true)
                        .keyboardType(.asciiCapable)
                        .textInputAutocapitalization(.never)
                        .multilineTextAlignment(.trailing)
                        .focused($focusedField, equals: .token)
                        .submitLabel(.done)
                        .onSubmit {
                            if (account.token.isEmpty || account.username.isEmpty || account.name.isEmpty ) { return }
                            
                            submitAction()
                        }
                } label: {
                    Text("Token")
                }
            }
        }
        .onAppear {
            focusedField = .accountName
        }
    }
}

struct AddAccountForm_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountForm(account: .constant(Account.emptyAccount), submitAction: {})
    }
}
