import SwiftUI

struct LockedAppView: View {
    @Binding var isAppLocked: Bool
    
    var body: some View {
        VStack {
            Group{
                VStack {
                    Image(systemName: "lock.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32)
                    
                    Text("Negi")
                }
                
                LargeButton(labelText: "Unlock") {
                    Task {
                        if await (LocalAuthenticationHandler.authenticate() == .success) {
                            isAppLocked = false
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 16)
        }
    }
}

struct LockedAppView_Previews: PreviewProvider {
    static var previews: some View {
        LockedAppView(isAppLocked: .constant(true))
    }
}
