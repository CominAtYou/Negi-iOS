import SwiftUI
import Foundation
import SwiftOTP

struct AccountDetailsView: View {
    let account: Account
    var totp: TOTP {
        return TOTP(secret: base32DecodeToData(account.token)!)!
    }
    @Binding var secondsToNextHop: Int
    @Binding var selectedAccount: Account?
    @EnvironmentObject var accountStore: AccountStore
    @State private var currentCode = ""
    @State private var nextCode = ""
    @State private var isPresentingAlert = false
    let saveAction: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Account info"), footer: Text("The next code will be available in \(secondsToNextHop) second\(secondsToNextHop == 1 ? "" : "s").")
                        ) {
                        LabeledContent {
                            Text(currentCode)
                        } label: {
                            Text("Veritifcation Code")
                        }
                        LabeledContent {
                            Text(nextCode)
                        } label: {
                            Text("Next Code")
                        }
                    }
                }
            }
            .navigationTitle(account.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Menu {
                    Button(role: .destructive, action: {
                        isPresentingAlert = true
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Label("Options", systemImage: "ellipsis.circle")
                }
            }
        }
        .onAppear {
            currentCode = totp.generate(time: Date())!
            nextCode = totp.generate(time: Date(timeIntervalSinceNow: TimeInterval(secondsToNextHop)))!
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                if (secondsToNextHop == 30) {
                    currentCode = nextCode
                    nextCode = totp.generate(time: Date(timeIntervalSinceNow: 30))!
                }
            })
        }
        .alert(isPresented: $isPresentingAlert) {
            Alert(
                title: Text("Delete Account?"),
                  message: Text("Are you sure you want to delete this account? You won't be able to get verification codes for the account any more."),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text("Delete")) {
                    selectedAccount = nil
                    accountStore.accounts.removeAll(where: {
                        $0.id == account.id
                    })
                    saveAction()
                }
            )
        }
    }
}

struct AccountDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailsView(account: Account.sampleData[0], secondsToNextHop: .constant(15), selectedAccount: .constant(nil), saveAction: {})
    }
}
