import SwiftUI
import Foundation

class AccountStore: ObservableObject {
    @Published var accounts: [Account] = []
    
    private static func getFileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("accounts.json")
    }
    
    func load() async throws {
        let task = Task<[Account], Error> {
            let fileURL = try Self.getFileURL()
            guard let data = try? Data(contentsOf: fileURL) else { return [] }
            let accounts = try JSONDecoder().decode([Account].self, from: data)
            NSLog("Retrieved %d accounts from AccountStore", accounts.count)
            
            return accounts
        }
        
        let savedAccounts = try await task.value
        self.accounts = savedAccounts
    }
    
    func save() async throws {
        let task = Task {
            let data = try JSONEncoder().encode(accounts)
            let outFile = try Self.getFileURL()
            try data.write(to: outFile)
            
            NSLog("Wrote %d accounts to AccountStore", accounts.count)
        }
        
        _ = try await task.value
    }
}
