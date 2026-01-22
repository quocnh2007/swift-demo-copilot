import XCTest
@testable import LoginFeature

@MainActor
final class LoginViewModelTests: XCTestCase {
    
    // MARK: - Test Properties
    
    var viewModel: LoginViewModel!
    var mockAuthService: MockAuthService!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        self.mockAuthService = MockAuthService(shouldSucceed: true, delay: 0.1)
        self.viewModel = LoginViewModel(authService: self.mockAuthService)
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.mockAuthService = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialState() {
        XCTAssertEqual(self.viewModel.username, "")
        XCTAssertEqual(self.viewModel.password, "")
        XCTAssertFalse(self.viewModel.isLoading)
        XCTAssertNil(self.viewModel.errorMessage)
        XCTAssertFalse(self.viewModel.isLoggedIn)
    }
    
    // MARK: - Successful Login Tests
    
    func testSuccessfulLogin() async {
        // Given
        self.viewModel.username = "demo"
        self.viewModel.password = "password"
        
        // When
        await self.viewModel.login()
        
        // Then
        XCTAssertTrue(self.viewModel.isLoggedIn)
        XCTAssertNil(self.viewModel.errorMessage)
        XCTAssertFalse(self.viewModel.isLoading)
    }
    
    func testLoginSetsLoadingState() async {
        // Given
        self.viewModel.username = "demo"
        self.viewModel.password = "password"
        
        // Create a longer delay to test loading state
        self.mockAuthService = MockAuthService(shouldSucceed: true, delay: 0.5)
        self.viewModel = LoginViewModel(authService: self.mockAuthService)
        self.viewModel.username = "demo"
        self.viewModel.password = "password"
        
        // When - Start login asynchronously
        let loginTask = Task {
            await self.viewModel.login()
        }
        
        // Give it a moment to start
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then - Should be loading
        XCTAssertTrue(self.viewModel.isLoading)
        
        // Wait for completion
        await loginTask.value
        
        // Then - Should finish loading
        XCTAssertFalse(self.viewModel.isLoading)
    }
    
    // MARK: - Failed Login Tests
    
    func testLoginWithEmptyUsername() async {
        // Given
        self.viewModel.username = ""
        self.viewModel.password = "password"
        
        // When
        await self.viewModel.login()
        
        // Then
        XCTAssertFalse(self.viewModel.isLoggedIn)
        XCTAssertNotNil(self.viewModel.errorMessage)
        XCTAssertEqual(self.viewModel.errorMessage, LoginError.emptyFields.errorDescription)
        XCTAssertFalse(self.viewModel.isLoading)
    }
    
    func testLoginWithEmptyPassword() async {
        // Given
        self.viewModel.username = "demo"
        self.viewModel.password = ""
        
        // When
        await self.viewModel.login()
        
        // Then
        XCTAssertFalse(self.viewModel.isLoggedIn)
        XCTAssertNotNil(self.viewModel.errorMessage)
        XCTAssertEqual(self.viewModel.errorMessage, LoginError.emptyFields.errorDescription)
        XCTAssertFalse(self.viewModel.isLoading)
    }
    
    func testLoginWithEmptyFields() async {
        // Given
        self.viewModel.username = ""
        self.viewModel.password = ""
        
        // When
        await self.viewModel.login()
        
        // Then
        XCTAssertFalse(self.viewModel.isLoggedIn)
        XCTAssertNotNil(self.viewModel.errorMessage)
        XCTAssertEqual(self.viewModel.errorMessage, LoginError.emptyFields.errorDescription)
        XCTAssertFalse(self.viewModel.isLoading)
    }
    
    func testLoginWithInvalidCredentials() async {
        // Given
        self.viewModel.username = "wronguser"
        self.viewModel.password = "wrongpassword"
        
        // When
        await self.viewModel.login()
        
        // Then
        XCTAssertFalse(self.viewModel.isLoggedIn)
        XCTAssertNotNil(self.viewModel.errorMessage)
        XCTAssertEqual(self.viewModel.errorMessage, LoginError.invalidCredentials.errorDescription)
        XCTAssertFalse(self.viewModel.isLoading)
    }
    
    func testLoginWithNetworkError() async {
        // Given
        self.mockAuthService = MockAuthService(shouldSucceed: false, delay: 0.1)
        self.viewModel = LoginViewModel(authService: self.mockAuthService)
        self.viewModel.username = "demo"
        self.viewModel.password = "password"
        
        // When
        await self.viewModel.login()
        
        // Then
        XCTAssertFalse(self.viewModel.isLoggedIn)
        XCTAssertNotNil(self.viewModel.errorMessage)
        XCTAssertEqual(self.viewModel.errorMessage, LoginError.networkError.errorDescription)
        XCTAssertFalse(self.viewModel.isLoading)
    }
    
    // MARK: - Reset Tests
    
    func testReset() async {
        // Given - Setup some state
        self.viewModel.username = "demo"
        self.viewModel.password = "password"
        await self.viewModel.login()
        
        // When
        self.viewModel.reset()
        
        // Then
        XCTAssertEqual(self.viewModel.username, "")
        XCTAssertEqual(self.viewModel.password, "")
        XCTAssertFalse(self.viewModel.isLoading)
        XCTAssertNil(self.viewModel.errorMessage)
        XCTAssertFalse(self.viewModel.isLoggedIn)
    }
    
    func testResetClearsError() async {
        // Given - Setup error state
        self.viewModel.username = ""
        self.viewModel.password = ""
        await self.viewModel.login()
        XCTAssertNotNil(self.viewModel.errorMessage)
        
        // When
        self.viewModel.reset()
        
        // Then
        XCTAssertNil(self.viewModel.errorMessage)
    }
    
    // MARK: - Multiple Login Attempts Tests
    
    func testMultipleLoginAttempts() async {
        // First attempt - fail
        self.viewModel.username = "wronguser"
        self.viewModel.password = "wrongpassword"
        await self.viewModel.login()
        XCTAssertFalse(self.viewModel.isLoggedIn)
        XCTAssertNotNil(self.viewModel.errorMessage)
        
        // Second attempt - succeed
        self.viewModel.username = "demo"
        self.viewModel.password = "password"
        await self.viewModel.login()
        XCTAssertTrue(self.viewModel.isLoggedIn)
        XCTAssertNil(self.viewModel.errorMessage)
    }
    
    func testErrorMessageClearedOnRetry() async {
        // Given - First failed attempt
        self.viewModel.username = ""
        self.viewModel.password = ""
        await self.viewModel.login()
        XCTAssertNotNil(self.viewModel.errorMessage)
        
        // When - Retry with valid credentials
        self.viewModel.username = "demo"
        self.viewModel.password = "password"
        await self.viewModel.login()
        
        // Then - Error should be cleared
        XCTAssertNil(self.viewModel.errorMessage)
        XCTAssertTrue(self.viewModel.isLoggedIn)
    }
}
