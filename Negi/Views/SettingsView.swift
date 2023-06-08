import SwiftUI
import LocalAuthentication

struct SettingsView: View {
    @State private var appLockEnabled = UserDefaults.standard.bool(forKey: "AppLockEnabled")
    private var supportedBiometrics: String {
        let context = LAContext()
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        return context.biometryType == .faceID ? "Face ID" : "Touch ID"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("General"), footer: Text("Require authentication via \(supportedBiometrics), your Apple Watch, or your passcode when opening Negi.")) {
                    Toggle(isOn: $appLockEnabled) {
                        Text("App Lock")
                    }
                    .onChange(of: appLockEnabled) { newValue in
                        NSLog("Value changed!")
                        if (!newValue) {
                            UserDefaults.standard.setValue(false, forKey: "AppLockEnabled")
                            return
                        }
                            
                        Task {
                            let result = await LocalAuthenticationHandler.authenticate()
                            
                            if (result == .success) {
                                UserDefaults.standard.setValue(true, forKey: "AppLockEnabled")
                            }
                            else {
                                appLockEnabled = false
                            }
                        }
                    }
                }
                
                Section(header: Text("Account Management"), footer: Text("Export your accounts to use them with another device or authenticator app.")) {
                    Button(action: {}) {
                        Text("Export Accounts")
                    }
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
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
