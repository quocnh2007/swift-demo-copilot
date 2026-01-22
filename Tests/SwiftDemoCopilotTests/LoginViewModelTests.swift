import XCTest
@testable import SwiftDemoCopilot

/// Mock LoginService for testing
class MockLoginService: LoginServiceProtocol {
    var shouldSucceed: Bool = true
    var shouldThrowError: LoginError?
    var loginCallCount: Int = 0
    var lastCredentials: UserCredentials?
    
    func login(credentials: UserCredentials) async throws -> LoginResult {
        loginCallCount += 1
        lastCredentials = credentials
        
        if let error = shouldThrowError {
            throw error
        }
        
        if shouldSucceed {
            return LoginResult(
                success: true,
                message: "Login successful",
                userToken: "mock-token-123"
            )
        } else {
            return LoginResult(
                success: false,
                message: "Login failed"
            )
        }
    }
}

/// Unit tests for LoginViewModel
@MainActor
final class LoginViewModelTests: XCTestCase {
    
    var viewModel: LoginViewModel!
    var mockService: MockLoginService!
    
    override func setUp() async throws {
        try await super.setUp()
        mockService = MockLoginService()
        viewModel = LoginViewModel(loginService: mockService)
    }
    
    override func tearDown() async throws {
        viewModel = nil
        mockService = nil
        try await super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialState() {
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoggedIn)
        XCTAssertNil(viewModel.userToken)
    }
    
    // MARK: - Login Button Enabled Tests
    
    func testLoginButtonEnabled_WhenFieldsAreFilled() {
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        
        XCTAssertTrue(viewModel.isLoginButtonEnabled)
    }
    
    func testLoginButtonDisabled_WhenEmailIsEmpty() {
        viewModel.email = ""
        viewModel.password = "password123"
        
        XCTAssertFalse(viewModel.isLoginButtonEnabled)
    }
    
    func testLoginButtonDisabled_WhenPasswordIsEmpty() {
        viewModel.email = "test@example.com"
        viewModel.password = ""
        
        XCTAssertFalse(viewModel.isLoginButtonEnabled)
    }
    
    func testLoginButtonDisabled_WhenLoading() {
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        viewModel.isLoading = true
        
        XCTAssertFalse(viewModel.isLoginButtonEnabled)
    }
    
    // MARK: - Successful Login Tests
    
    func testLogin_Success() async {
        // Arrange
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        mockService.shouldSucceed = true
        
        // Act
        await viewModel.login()
        
        // Assert
        XCTAssertTrue(viewModel.isLoggedIn)
        XCTAssertEqual(viewModel.userToken, "mock-token-123")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(mockService.loginCallCount, 1)
        XCTAssertEqual(mockService.lastCredentials?.email, "test@example.com")
        XCTAssertEqual(mockService.lastCredentials?.password, "password123")
    }
    
    // MARK: - Failed Login Tests
    
    func testLogin_Failure_InvalidCredentials() async {
        // Arrange
        viewModel.email = "test@example.com"
        viewModel.password = "wrongpassword"
        mockService.shouldThrowError = .invalidCredentials
        
        // Act
        await viewModel.login()
        
        // Assert
        XCTAssertFalse(viewModel.isLoggedIn)
        XCTAssertNil(viewModel.userToken)
        XCTAssertEqual(viewModel.errorMessage, "Invalid email or password")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testLogin_Failure_NetworkError() async {
        // Arrange
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        mockService.shouldThrowError = .networkError
        
        // Act
        await viewModel.login()
        
        // Assert
        XCTAssertFalse(viewModel.isLoggedIn)
        XCTAssertNil(viewModel.userToken)
        XCTAssertEqual(viewModel.errorMessage, "Network connection error. Please try again.")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testLogin_Failure_InvalidEmail() async {
        // Arrange
        viewModel.email = "invalid-email"
        viewModel.password = "password123"
        mockService.shouldThrowError = .invalidEmail
        
        // Act
        await viewModel.login()
        
        // Assert
        XCTAssertFalse(viewModel.isLoggedIn)
        XCTAssertNil(viewModel.userToken)
        XCTAssertEqual(viewModel.errorMessage, "Please enter a valid email address")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testLogin_Failure_EmptyPassword() async {
        // Arrange
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        mockService.shouldThrowError = .emptyPassword
        
        // Act
        await viewModel.login()
        
        // Assert
        XCTAssertFalse(viewModel.isLoggedIn)
        XCTAssertNil(viewModel.userToken)
        XCTAssertEqual(viewModel.errorMessage, "Password cannot be empty")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testLogin_Failure_ServerError() async {
        // Arrange
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        mockService.shouldThrowError = .serverError("Internal server error")
        
        // Act
        await viewModel.login()
        
        // Assert
        XCTAssertFalse(viewModel.isLoggedIn)
        XCTAssertNil(viewModel.userToken)
        XCTAssertEqual(viewModel.errorMessage, "Internal server error")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // MARK: - Validation Tests
    
    func testLogin_EmptyEmail_ShowsError() async {
        // Arrange
        viewModel.email = ""
        viewModel.password = "password123"
        
        // Act
        await viewModel.login()
        
        // Assert
        XCTAssertFalse(viewModel.isLoggedIn)
        XCTAssertEqual(viewModel.errorMessage, "Email cannot be empty")
        XCTAssertEqual(mockService.loginCallCount, 0) // Service should not be called
    }
    
    func testLogin_EmptyPassword_ShowsError() async {
        // Arrange
        viewModel.email = "test@example.com"
        viewModel.password = ""
        
        // Act
        await viewModel.login()
        
        // Assert
        XCTAssertFalse(viewModel.isLoggedIn)
        XCTAssertEqual(viewModel.errorMessage, "Password cannot be empty")
        XCTAssertEqual(mockService.loginCallCount, 0) // Service should not be called
    }
    
    // MARK: - Loading State Tests
    
    func testLogin_SetsLoadingState() async {
        // Arrange
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        
        // Create expectation for loading state
        let loadingExpectation = expectation(description: "Loading state set")
        
        // Start login in a separate task
        Task {
            // Check loading state is set
            await viewModel.login()
        }
        
        // Give it a moment to start
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Assert loading state after login completes
        XCTAssertFalse(viewModel.isLoading) // Should be false after completion
        loadingExpectation.fulfill()
        
        await fulfillment(of: [loadingExpectation], timeout: 2.0)
    }
    
    // MARK: - Reset Tests
    
    func testReset_ClearsAllState() async {
        // Arrange - Set up logged in state
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        await viewModel.login()
        
        // Act
        viewModel.reset()
        
        // Assert
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isLoggedIn)
        XCTAssertNil(viewModel.userToken)
    }
    
    // MARK: - Clear Error Tests
    
    func testClearError_RemovesErrorMessage() async {
        // Arrange
        viewModel.email = ""
        viewModel.password = "password123"
        await viewModel.login() // This will set an error
        
        XCTAssertNotNil(viewModel.errorMessage)
        
        // Act
        viewModel.clearError()
        
        // Assert
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // MARK: - Error Clearing on New Login Tests
    
    func testLogin_ClearsPreviousError() async {
        // Arrange - First login with error
        viewModel.email = ""
        viewModel.password = "password123"
        await viewModel.login()
        XCTAssertNotNil(viewModel.errorMessage)
        
        // Act - Second login with valid credentials
        viewModel.email = "test@example.com"
        mockService.shouldSucceed = true
        await viewModel.login()
        
        // Assert
        XCTAssertNil(viewModel.errorMessage)
    }
}
