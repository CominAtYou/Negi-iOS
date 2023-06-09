import SwiftUI
import LocalAuthentication

struct SettingsView: View {
    @State private var appLockEnabled = UserDefaults.standard.bool(forKey: "AppLockEnabled")
    private var supportedBiometrics: String {
        let context = LAContext()
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        return context.biometryType == .faceID ? "Face ID" : "Touch ID"
    }
    @Binding var accounts: [Account]
    @State private var isPresntingAlertDialog = false
    @State private var isPresentingExportSheet = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("General"), footer: Text("Require authentication via \(supportedBiometrics), your Apple Watch, or your passcode when opening Negi.")) {
                    Toggle(isOn: $appLockEnabled) {
                        Text("App Lock")
                    }
                    .onChange(of: appLockEnabled) { newValue in
                        if (!newValue) {
                            UserDefaults.standard.setValue(false, forKey: "AppLockEnabled")
                            return
                        }
                            
                        Task {
                            let result = await LocalAuthenticationHandler.authenticate()
                            
                            if (result == .success) {
                                UserDefaults.standard.setValue(true, forKey: "AppLockEnabled")
                            }
                            else if (result == .incompatiblePolicy) {
                                isPresntingAlertDialog = true
                                appLockEnabled = false
                            }
                            else {
                                appLockEnabled = false
                            }
                        }
                    }
                }
                
                Section(header: Text("Account Management"), footer: Text("Export your accounts to use them with another device or authenticator app.")) {
                    Button(action: {
                        Task {
                            let result = await LocalAuthenticationHandler.authenticate()
                            if (result == .success || result == .incompatiblePolicy) {
                                do {
                                    let controller = UIActivityViewController(activityItems: [try AccountStore.getFileURL()], applicationActivities: nil)
                                    (UIApplication.shared.connectedScenes.first?.delegate as? UIWindowSceneDelegate)?.window!?.rootViewController?.present(controller, animated: true)
                                }
                                catch {
                                    fatalError(error.localizedDescription)
                                }
                            }
                        }
                    }) {
                        Text("Export Accounts")
                    }
                    .disabled(accounts.count == 0)
                }
                
                Section(header: Text("About"), footer: Text("© 2023 CominAtYou. All rights reserved.")) {
                    LabeledContent {
                        Text(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)
                    } label: {
                        Text("Version")
                    }
                    
                    NavigationLink(destination: Text("todo")) {
                        Text("Open Source Licenses")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert(isPresented: $isPresntingAlertDialog) {
            Alert(title: Text("App Lock Unavailable"), message: Text("You must set up a passcode in Settings in order to use app lock."))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(accounts: .constant(Account.sampleData))
    }
}
