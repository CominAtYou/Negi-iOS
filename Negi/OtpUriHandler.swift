import Foundation
import SwiftOTP

class OtpUriHandler {
    static func createAccountFromUri(uri: String) -> Account? {
        guard let parsedUrl = URL(string: uri) else {
            NSLog("Failed to parse URI: %s", uri)
            return nil
        }
        if (parsedUrl.scheme != "otpauth") { return nil }
        
        let username = parsedUrl.lastPathComponent
        guard let queryItems = URLComponents(string: uri)!.queryItems else { return nil }
        guard let tokenParam = queryItems.first(where: { $0.name == "secret" }) else { return nil }
        guard let rawToken = tokenParam.value else { return nil }
        let issuerParam = queryItems.first(where: { $0.name == "issuer" })
        let issuer = issuerParam == nil ? username : issuerParam!.value ?? username
        
        let token = base32DecodeToData(rawToken) != nil ? rawToken : base32Encode(rawToken.data(using: .utf8)!)
        return Account(name: issuer, username: username, token: token)
    }
}
