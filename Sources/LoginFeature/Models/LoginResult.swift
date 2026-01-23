import Foundation

/// Represents the result of a successful login
public struct LoginResult {
    public let userId: String
    public let token: String
    public let username: String
    
    public init(userId: String, token: String, username: String) {
        self.userId = userId
        self.token = token
        self.username = username
    }
}
