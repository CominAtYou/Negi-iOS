import SwiftUI
import Foundation
import SwiftOTP

struct AccountDetailsView: View {
    let account: Account
    var totp: TOTP {
        return TOTP(secret: base32DecodeToData(account.token)!)!
    }
    @Binding var secondsToNextHop: Int
    @State private var currentCode = ""
    @State private var nextCode = ""
    @State var hasFirstInitCompleted = false
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
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
                .padding(.horizontal, sizeClass == .regular ? 40 : 0)
            }
        }
        .background(Color(colorScheme == .dark ? UIColor.systemBackground : UIColor.secondarySystemBackground))
        .navigationTitle(account.name)
        .navigationBarTitleDisplayMode(.inline)
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
    }
}

struct AccountDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailsView(account: Account.sampleData[0], secondsToNextHop: .constant(15))
    }
}