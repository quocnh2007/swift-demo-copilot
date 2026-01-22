# Usage Example

This document demonstrates how to use the Login screen implementation in your SwiftUI app.

## Basic Usage

### 1. Import the module

```swift
import SwiftUI
import SwiftDemoCopilot
```

### 2. Use the LoginView in your app

```swift
import SwiftUI
import SwiftDemoCopilot

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
```

### 3. Custom ViewModel Usage

You can also create a custom instance of LoginViewModel with dependency injection:

```swift
import SwiftUI
import SwiftDemoCopilot

struct ContentView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        LoginView(viewModel: viewModel)
    }
}
```

### 4. Custom Login Service

Implement your own `LoginServiceProtocol` for real API calls:

```swift
import SwiftDemoCopilot

class MyLoginService: LoginServiceProtocol {
    func login(credentials: UserCredentials) async throws -> LoginResult {
        // Your custom API call here
        let url = URL(string: "https://api.example.com/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body = [
            "email": credentials.email,
            "password": credentials.password
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw LoginError.networkError
        }
        
        // Parse response and return LoginResult
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let token = json?["token"] as? String
        
        return LoginResult(
            success: true,
            message: "Login successful",
            userToken: token
        )
    }
}

// Usage
let customService = MyLoginService()
let viewModel = LoginViewModel(loginService: customService)
let loginView = LoginView(viewModel: viewModel)
```

## Demo Credentials

For testing with the default `LoginService`, use:

**Success:**
- Email: `test@example.com`
- Password: `password123`

**Server Error:**
- Email: `error@example.com`
- Password: any

**Invalid Credentials:**
- Any other combination

## ViewModel Properties

The `LoginViewModel` exposes the following properties:

- `email: String` - User's email input
- `password: String` - User's password input
- `isLoading: Bool` - Loading state during login
- `errorMessage: String?` - Error message to display
- `isLoggedIn: Bool` - Login success state
- `userToken: String?` - Authentication token after successful login
- `isLoginButtonEnabled: Bool` - Computed property for button state

## ViewModel Methods

- `func login() async` - Performs login with current credentials
- `func reset()` - Resets all state to initial values
- `func clearError()` - Clears the current error message

## Error Types

The library defines several error types:

- `LoginError.invalidCredentials` - Wrong email/password
- `LoginError.networkError` - Network connection issue
- `LoginError.serverError(String)` - Server-side error with message
- `LoginError.invalidEmail` - Invalid email format
- `LoginError.emptyPassword` - Password field is empty

All errors provide localized descriptions for user display.
