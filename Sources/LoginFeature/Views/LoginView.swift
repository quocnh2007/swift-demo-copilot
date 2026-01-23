import SwiftUI

/// Login screen view
/// Provides UI for username/password input and authentication
public struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ZStack {
                // Main content
                VStack(spacing: 20) {
                    // Logo or title
                    Text("Welcome")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 40)
                    
                    // Username field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Username")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("Enter your username", text: self.$viewModel.username)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.username)
                            .autocapitalization(.none)
                            .disabled(self.viewModel.isLoading)
                    }
                    
                    // Password field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        SecureField("Enter your password", text: self.$viewModel.password)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.password)
                            .disabled(self.viewModel.isLoading)
                    }
                    
                    // Error message
                    if let errorMessage = self.viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    // Login button
                    Button(action: {
                        Task {
                            await self.viewModel.login()
                        }
                    }) {
                        if self.viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                        }
                        else {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 50)
                    .background(self.viewModel.isLoading ? Color.gray : Color.blue)
                    .cornerRadius(10)
                    .disabled(self.viewModel.isLoading)
                    .padding(.top, 20)
                    
                    // Demo credentials hint
                    Text("Demo: username='demo', password='password'")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.top, 20)
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 60)
                
                // Success overlay
                if self.viewModel.isLoggedIn {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        
                        Text("Login Successful!")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Button("Continue") {
                            self.viewModel.reset()
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(40)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 20)
                }
            }
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Previews

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
