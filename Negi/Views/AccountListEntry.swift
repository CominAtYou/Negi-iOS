import SwiftUI

struct AccountListEntry: View {
    let account: Account
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        HStack {
            Text(account.name.prefix(1))
                .font(.system(size: 20))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(width: 35, height: 35)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.gray)
                )
                .padding(.trailing, sizeClass == .regular ? 0 : 4)
            VStack(alignment: .leading) {
                Text(account.name)
                
                Spacer()
                    .frame(height: 2)
                
                Text(account.username)
                    .font(.subheadline)
                    .opacity(0.6)
                    .lineLimit(1)
            }
            
            Spacer()
        }
    }
}

struct AccountListEntry_Previews: PreviewProvider {
    static var previews: some View {
        AccountListEntry(account: Account.sampleData[0])
    }
}
