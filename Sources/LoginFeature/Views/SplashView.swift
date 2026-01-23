import SwiftUI

/// Splash screen view
/// Displays a splash screen for 3 seconds before navigating to the login screen
public struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel()
    
    public init() {}
    
    public var body: some View {
        if self.viewModel.shouldShowLogin {
            LoginView()
        }
        else {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Content
                VStack(spacing: 20) {
                    // App icon or logo
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                    
                    // App name
                    Text("Login Demo")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    // Loading indicator
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .padding(.top, 40)
                }
            }
            .onAppear {
                self.viewModel.startTimer()
            }
        }
    }
}

// MARK: - Previews

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
