# Swift & SwiftUI Coding Instructions

You are an expert iOS developer specialized in Swift and SwiftUI. Follow these rules strictly for this project.

## 1. Tech Stack & Architecture
- **Language:** Swift 5+ (Latest version).
- **UI Framework:** SwiftUI.
- **Architecture:** MVVM (Model-View-ViewModel).
  - **Model:** Structs only (Immutable data).
  - **ViewModel:** Classes conforming to `ObservableObject`, using `@Published` properties. Handles all business logic.
  - **View:** Pure SwiftUI views. No logic inside Views (pass actions to ViewModel).

## 2. Coding Style & Conventions
- **Explicit Self:**
  - **ALWAYS** use `self.` when accessing instance properties or methods to distinguish them from local variables.
  - Example: Use `self.totalNumber += 1` instead of `totalNumber += 1`.
- **Formatting & Control Flow:**
  - **Newline for Else:** The `else` keyword (and `catch`) must strictly be placed on a **new line** after the closing brace `}`.
  - **Braces:** Use "One True Brace Style" (opening brace on the same line) for the start of the block, but break before `else`.
- **Naming:**
  - Use `PascalCase` for Types (Structs, Classes, Enums, Protocols).
  - Use `camelCase` for variables, functions, and parameters.
- **Safety:**
  - Avoid Force Unwrapping (`!`) at all costs. Use `if let`, `guard let`, or nil-coalescing (`??`).

## 3. Concurrency
- Use modern Swift Concurrency (`async`/`await`).
- Ensure UI updates happen on the `@MainActor`.

## 4. Example Code Style
When generating code, strictly follow this formatting pattern:

```swift
// ViewModel
@MainActor
final class TaskViewModel: ObservableObject {
    @Published var count: Int = 0
    @Published var isLoading: Bool = false
    
    func incrementCount() {
        if self.isLoading {
            return
        }
        else {
            // Note the use of 'self.' and the 'else' on a new line
            self.count += 1
            self.doSomethingElse()
        }
    }
    
    func doSomethingElse() {
        print("Done")
    }
}

5. View Structure
- Use @StateObject for initializing ViewModels in the owner View.
- Use @ObservedObject for passing ViewModels to subviews.

```swift
struct TaskListView: View {
    @StateObject private var viewModel = TaskViewModel()
    
    var body: some View {
        VStack {
            Text("Count: \(self.viewModel.count)")
            
            if self.viewModel.isLoading {
                ProgressView()
            }
            else {
                Button("Increment") {
                    self.viewModel.incrementCount()
                }
            }
        }
    }
}
