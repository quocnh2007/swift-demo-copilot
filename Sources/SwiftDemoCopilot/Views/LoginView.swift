#if canImport(SwiftUI)
import SwiftUI

/// Login screen view following MVVM pattern
@available(iOS 16.0, macOS 13.0, *)
public struct LoginView: View {
    
    @StateObject private var viewModel: LoginViewModel
    
    public init(viewModel: LoginViewModel = LoginViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Logo or App Title
                Text("Welcome")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 50)
                
                // Email/Username Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("Enter your email", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .disabled(viewModel.isLoading)
                }
                .padding(.horizontal)
                
                // Password Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    SecureField("Enter your password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(viewModel.isLoading)
                }
                .padding(.horizontal)
                
                // Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                }
                
                // Login Button
                Button(action: {
                    Task {
                        await viewModel.login()
                    }
                }) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        Text(viewModel.isLoading ? "Logging in..." : "Login")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isLoginButtonEnabled ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(!viewModel.isLoginButtonEnabled)
                .padding(.horizontal)
                .padding(.top, 20)
                
                Spacer()
            }
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Login Successful", isPresented: $viewModel.isLoggedIn) {
                Button("OK") {
                    viewModel.reset()
                }
            } message: {
                Text("You have successfully logged in!")
            }
        }
    }
}

// MARK: - Preview Provider

@available(iOS 16.0, macOS 13.0, *)
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
#endif
