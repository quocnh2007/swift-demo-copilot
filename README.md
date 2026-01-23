# Swift Demo Copilot - Login Feature

A demonstration project showcasing MVVM architecture with SwiftUI and async/await for iOS development.

## Overview

This project implements a complete Login screen following strict MVVM (Model-View-ViewModel) architecture patterns with modern Swift concurrency (async/await).

## Features

- ✅ **MVVM Architecture**: Clear separation between Model, View, and ViewModel
- ✅ **Splash Screen**: Animated splash screen with 3-second timer and auto-navigation
- ✅ **Async/Await**: Modern Swift concurrency for asynchronous operations
- ✅ **SwiftUI**: Declarative UI framework
- ✅ **Error Handling**: Comprehensive error handling for login failures
- ✅ **Unit Tests**: Complete test coverage for ViewModel logic
- ✅ **Mock Authentication**: Demo authentication service for testing

## Project Structure

```
LoginFeature/
├── Models/
│   ├── LoginCredentials.swift    # Immutable struct for credentials
│   ├── LoginResult.swift          # Immutable struct for login result
│   └── LoginError.swift           # Error types for login failures
├── ViewModels/
│   ├── LoginViewModel.swift       # @MainActor ObservableObject handling business logic
│   └── SplashViewModel.swift      # ViewModel for splash screen timer
├── Views/
│   ├── LoginView.swift            # SwiftUI view for login screen
│   └── SplashView.swift           # SwiftUI view for splash screen
└── Services/
    ├── AuthService.swift          # Protocol for authentication
    └── MockAuthService.swift      # Mock implementation for testing

Tests/
└── LoginFeatureTests/
    ├── LoginViewModelTests.swift  # Comprehensive unit tests
    └── SplashViewModelTests.swift # Tests for splash screen timer
```

## Requirements

- **iOS 16.0+** or **macOS 13.0+**
- **Xcode 14.0+**
- **Swift 5.9+**

## Installation & Usage

### Opening the Project

This is a Swift Package Manager project. To use it:

1. Open the project in **Xcode** on macOS:
   ```bash
   open Package.swift
   ```

2. Or add it as a dependency to your app:
   ```swift
   dependencies: [
       .package(url: "your-repo-url", from: "1.0.0")
   ]
   ```

### Using the App

The app now starts with a splash screen that displays for 3 seconds before navigating to the login screen:

```swift
import SwiftUI
import LoginFeature

@main
struct YourApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView()  // Shows splash screen first, then auto-navigates to LoginView
        }
    }
}
```

You can also use the login screen directly if you don't want the splash screen:

```swift
import SwiftUI
import LoginFeature

@main
struct YourApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
```

### Demo Credentials

The mock authentication service accepts these credentials:
- **Username**: `demo`
- **Password**: `password`

## Architecture Details

### MVVM Pattern

#### Model Layer
- Immutable structs only
- `LoginCredentials`: User input data
- `LoginResult`: Authentication response
- `LoginError`: Typed error cases

#### ViewModel Layer
- `LoginViewModel`: ObservableObject class
- Marked with `@MainActor` for UI thread safety
- Uses `@Published` properties for reactive state
- Implements async `login()` method
- Handles all business logic

#### View Layer
- Pure SwiftUI views
- No business logic (delegates to ViewModel)
- Uses `@StateObject` for ViewModel ownership
- Reactive UI updates via property bindings

### Coding Standards

This project follows strict coding conventions:

1. **Explicit Self**: Always use `self.` for instance properties
   ```swift
   self.username = ""  // ✅ Correct
   username = ""       // ❌ Incorrect
   ```

2. **Newline for Else**: `else` keyword on new line
   ```swift
   if condition {
       // code
   }
   else {  // ✅ Correct - else on new line
       // code
   }
   ```

3. **Safety First**: No force unwrapping
   ```swift
   if let value = optional { }  // ✅ Correct
   let value = optional!        // ❌ Incorrect
   ```

## Testing

Run tests in Xcode:
```bash
swift test  # On macOS with Xcode installed
```

Or use Xcode:
1. Open `Package.swift` in Xcode
2. Press `Cmd + U` to run tests

### Test Coverage

The test suite includes:

#### LoginViewModel Tests
- ✅ Initial state validation
- ✅ Successful login flow
- ✅ Loading state management
- ✅ Empty field validation
- ✅ Invalid credentials handling
- ✅ Network error scenarios
- ✅ Reset functionality
- ✅ Multiple login attempts
- ✅ Error message clearing

#### SplashViewModel Tests
- ✅ Initial state validation
- ✅ Timer completion after 3 seconds
- ✅ Navigation state before timer completes

## API Reference

### LoginViewModel

```swift
@MainActor
final class LoginViewModel: ObservableObject {
    @Published var username: String
    @Published var password: String
    @Published var isLoading: Bool
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool
    
    func login() async
    func reset()
}
```

### AuthService Protocol

```swift
protocol AuthService {
    func authenticate(credentials: LoginCredentials) async throws -> LoginResult
}
```

## Integration

To integrate with a real authentication backend:

1. Create a new class conforming to `AuthService`:
   ```swift
   final class RealAuthService: AuthService {
       func authenticate(credentials: LoginCredentials) async throws -> LoginResult {
           // Call your API endpoint
           // Parse response
           // Return LoginResult or throw LoginError
       }
   }
   ```

2. Initialize ViewModel with your service:
   ```swift
   let viewModel = LoginViewModel(authService: RealAuthService())
   ```

## Platform Notes

**Important**: SwiftUI is only available on Apple platforms (iOS, macOS, watchOS, tvOS). 

- The Models and Services can be built on Linux for testing core logic
- The Views and ViewModel with SwiftUI require macOS/Xcode to build and run
- For CI/CD on Linux, consider excluding SwiftUI-dependent files or using conditional compilation

## License

MIT License

## Contributing

Please follow the coding standards defined in `.github/copilot-instructions.md` when contributing.
