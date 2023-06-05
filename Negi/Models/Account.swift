import Foundation

struct Account: Identifiable, Codable {
    var name: String
    var username: String
    var token: String
    let id: UUID
    
    init(name: String, username: String, token: String, id: UUID = UUID()) {
        self.name = name
        self.username = username
        self.token = token
        self.id = id
    }
}

extension Account {
    static let sampleData: [Account] = [
        Account(name: "Google", username: "hikingfan101@gmail.com", token: ""),
        Account(name: "Discord", username: "Miku#0001", token: ""),
        Account(name: "Spotify", username: "Miku", token: "")
    ]
    
    static var emptyAccount: Account {
        Account(name: "", username: "", token: "")
    }
}
