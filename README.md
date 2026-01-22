# Swift Demo Copilot

A Swift project demonstrating MVVM (Model-View-ViewModel) architecture with async/await for a Login screen implementation.

## Features

- ✅ MVVM Architecture
- ✅ SwiftUI (iOS 16+, macOS 13+)
- ✅ Async/await for asynchronous operations
- ✅ Comprehensive unit tests
- ✅ Clean separation of concerns
- ✅ Type-safe error handling

## Project Structure

```
Sources/SwiftDemoCopilot/
├── Models/
│   └── LoginModels.swift         # Data models (UserCredentials, LoginResult, LoginError)
├── Services/
│   └── LoginService.swift        # Network/API layer with async/await
├── ViewModels/
│   └── LoginViewModel.swift      # Business logic and state management
└── Views/
    └── LoginView.swift           # SwiftUI user interface

Tests/SwiftDemoCopilotTests/
├── LoginServiceTests.swift       # Tests for LoginService
└── LoginViewModelTests.swift     # Tests for LoginViewModel
```

## Architecture

### Model Layer
- **UserCredentials**: Represents user login credentials (email, password)
- **LoginResult**: Contains the result of a login attempt
- **LoginError**: Defines all possible login errors with user-friendly messages

### Service Layer
- **LoginService**: Handles the network/API logic
  - Uses async/await for asynchronous operations
  - Validates email format using regex
  - Simulates network delay for realistic behavior
  - Implements email validation

### ViewModel Layer
- **LoginViewModel**: Manages UI state and business logic
  - `@MainActor` for thread-safe UI updates
  - `@Published` properties for reactive updates (on Apple platforms)
  - Async login method using async/await
  - Input validation before API calls
  - Comprehensive error handling

### View Layer
- **LoginView**: SwiftUI interface
  - Email and password input fields
  - Login button with loading state
  - Error message display
  - Success alert dialog
  - Disabled button state management

## Usage

### Demo Credentials

For testing purposes, the following credentials work:

**Successful Login:**
- Email: `test@example.com`
- Password: `password123`

**Server Error Simulation:**
- Email: `error@example.com`
- Password: (any password)

**Invalid Credentials:**
- Any other email/password combination

### Running Tests

```bash
swift test
```

All tests pass successfully:
- 8 LoginService tests
- 17 LoginViewModel tests

### Building

```bash
swift build
```

## Requirements

- Swift 5.9+
- iOS 16+ / macOS 13+ (for SwiftUI features)

## Implementation Highlights

### 1. Async/Await Pattern

All asynchronous operations use Swift's modern async/await:

```swift
public func login() async {
    // ... validation ...
    
    do {
        let result = try await loginService.login(credentials: credentials)
        // Handle result
    } catch {
        // Handle error
    }
}
```

### 2. MVVM Separation

- **View**: Only knows about the ViewModel, never directly accesses services
- **ViewModel**: Handles all UI logic, validation, and coordinates with services
- **Model/Service**: Pure business logic and data handling

### 3. Error Handling

Clear, user-friendly error messages for all scenarios:
- Invalid email format
- Empty password
- Invalid credentials
- Network errors
- Server errors

### 4. State Management

The ViewModel manages all UI states:
- Loading state
- Error messages
- Login success
- Form validation

### 5. Testing

Comprehensive unit tests covering:
- Successful login scenarios
- Various failure scenarios
- Input validation
- State management
- Error handling

### 6. Cross-Platform Support

The code uses conditional compilation to work on both:
- Apple platforms (with SwiftUI and Combine)
- Linux (for testing and CI/CD)

## License

This is a demo project for educational purposes.
