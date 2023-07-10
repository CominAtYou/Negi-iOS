import SwiftUI
import Foundation

class AccountStore: ObservableObject {
    @Published var accounts: [Account] = []
    
    static func getFileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("accounts.json")
    }
    
    func load() async throws {
        let task = Task<[Account], Error> {
            let fileURL = try Self.getFileURL()
            guard let data = try? Data(contentsOf: fileURL) else { return [] }
            let accounts = try JSONDecoder().decode([Account].self, from: data)
            NSLog("Retrieved %d account(s) from AccountStore", accounts.count)
            
            return accounts
        }
        
        let savedAccounts = try await task.value
        await MainActor.run {
            self.accounts = savedAccounts
        }
    }
    
    func save() {
        Task {
            do {
                let data = try JSONEncoder().encode(accounts)
                let outFile = try Self.getFileURL()
                try data.write(to: outFile)
                
                NSLog("Wrote %d account(s) to AccountStore", accounts.count)
            }
            catch {
                // TODO: Do something instead of this
                fatalError(error.localizedDescription)
            }
        }
    }
}
