# Quick Start Guide

## For Developers

### Prerequisites
- macOS 13.0 or later
- Xcode 14.0 or later
- iOS 16.0+ (for running on device/simulator)

### Opening the Project

```bash
# Clone the repository
git clone <repository-url>
cd swift-demo-copilot

# Open in Xcode
open Package.swift
```

### Building the Project

#### In Xcode
1. Open `Package.swift` in Xcode
2. Select the target device (iPhone simulator or Mac)
3. Press `Cmd + B` to build

#### Command Line (macOS only)
```bash
swift build
```

### Running Tests

#### In Xcode
1. Press `Cmd + U` to run all tests
2. Or select individual test from the Test Navigator

#### Command Line (macOS only)
```bash
swift test
```

### Using the Login Screen

#### In a New App

1. Create a new iOS App project in Xcode
2. Add this package as a dependency:
   - File → Add Package Dependencies
   - Enter the repository URL
   
3. Import and use:
```swift
import SwiftUI
import LoginFeature

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
```

#### Quick Preview in Xcode

1. Open `Sources/LoginFeature/Views/LoginView.swift`
2. Press `Cmd + Option + Enter` to show preview
3. Click "Resume" if needed

### Testing the Login

Use these demo credentials:
- **Username**: demo
- **Password**: password

### Customizing Authentication

Replace `MockAuthService` with your own implementation:

```swift
import LoginFeature

final class MyAuthService: AuthService {
    func authenticate(credentials: LoginCredentials) async throws -> LoginResult {
        // Your API call here
        let response = try await yourAPI.login(...)
        return LoginResult(userId: response.id, token: response.token, username: credentials.username)
    }
}

// Use it
let viewModel = LoginViewModel(authService: MyAuthService())
```

### Project Structure

```
LoginFeature/
├── Models/          # Data structures (Codable structs)
├── ViewModels/      # Business logic (ObservableObject)
├── Views/           # UI (SwiftUI)
└── Services/        # APIs and external services
```

### Key Files

- `LoginView.swift` - Main UI
- `LoginViewModel.swift` - Business logic
- `LoginCredentials.swift` - Input model
- `LoginResult.swift` - Output model
- `AuthService.swift` - Authentication protocol
- `MockAuthService.swift` - Demo implementation

### Common Tasks

#### Change Demo Credentials
Edit `MockAuthService.swift`:
```swift
if credentials.username == "your-username" && credentials.password == "your-password" {
    // ...
}
```

#### Add New Fields
1. Add to Model: `LoginCredentials.swift`
2. Add @Published property to ViewModel: `LoginViewModel.swift`
3. Add TextField to View: `LoginView.swift`

#### Customize UI Colors
Edit `LoginView.swift`:
```swift
.background(Color.blue)  // Change to your brand color
```

### Troubleshooting

#### SwiftUI Not Found
- **Cause**: Running on Linux or without Xcode
- **Solution**: Build on macOS with Xcode installed

#### Tests Not Running
- **Cause**: Wrong platform selected
- **Solution**: Select an iOS simulator or "My Mac" as target

#### Module 'LoginFeature' Not Found
- **Cause**: Package not added to dependencies
- **Solution**: Add package dependency in Xcode

### Next Steps

1. Review the [README.md](README.md) for full documentation
2. Check [IMPLEMENTATION.md](IMPLEMENTATION.md) for architecture details
3. See [Examples/UI_SPECIFICATION.md](Examples/UI_SPECIFICATION.md) for UI design
4. Run tests to understand the behavior
5. Customize for your needs

### Code Style

This project follows strict guidelines:
- ✅ Always use `self.` for instance properties
- ✅ Put `else` on a new line
- ✅ No force unwrapping (`!`)
- ✅ Use async/await for async code

See `.github/copilot-instructions.md` for complete style guide.

### Getting Help

1. Check existing documentation files
2. Review unit tests for usage examples
3. Look at `MockAuthService.swift` for implementation patterns

### Contributing

1. Follow the coding standards in `.github/copilot-instructions.md`
2. Write tests for new features
3. Update documentation
4. Ensure all tests pass before submitting PR

---

Happy coding! 🚀
