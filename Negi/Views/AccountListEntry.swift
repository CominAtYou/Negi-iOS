import SwiftUI

struct AccountListEntry: View {
    let account: Account
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
    Label {
        VStack(alignment: .leading) {
            Text(account.name)
                .foregroundColor(Color(UIColor.label))
            
            Spacer()
                .frame(height: 2)
            
            Text(account.username)
                .font(.subheadline)
                .foregroundColor(Color(UIColor.label))
                .opacity(0.6)
                .lineLimit(1)
        }
        
        Spacer()
        } icon: {
            let imageExists = UIImage(systemName: "\(account.name.prefix(1).lowercased()).circle.fill") != nil
            Image(systemName: imageExists ? "\(account.name.prefix(1).lowercased()).circle.fill" : "person.circle.fill")
                .symbolRenderingMode(.multicolor)
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundColor(.gray)
        }
        .labelStyle(CenteredIconLabelStyle())
    }
}

struct CenteredIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            configuration.icon
                .padding(.trailing, 15)
            configuration.title
        }
    }
}

struct AccountListEntry_Previews: PreviewProvider {
    static var previews: some View {
        AccountListEntry(account: Account.sampleData[0])
    }
}
