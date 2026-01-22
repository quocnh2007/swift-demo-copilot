import XCTest
@testable import SwiftDemoCopilot

/// Unit tests for LoginService
final class LoginServiceTests: XCTestCase {
    
    var service: LoginService!
    
    override func setUp() {
        super.setUp()
        service = LoginService()
    }
    
    override func tearDown() {
        service = nil
        super.tearDown()
    }
    
    // MARK: - Successful Login Tests
    
    func testLogin_WithValidCredentials_ReturnsSuccess() async throws {
        // Arrange
        let credentials = UserCredentials(
            email: "test@example.com",
            password: "password123"
        )
        
        // Act
        let result = try await service.login(credentials: credentials)
        
        // Assert
        XCTAssertTrue(result.success)
        XCTAssertEqual(result.message, "Login successful")
        XCTAssertNotNil(result.userToken)
        XCTAssertTrue(result.userToken?.starts(with: "demo-token-") ?? false)
    }
    
    // MARK: - Failed Login Tests
    
    func testLogin_WithInvalidCredentials_ThrowsError() async {
        // Arrange
        let credentials = UserCredentials(
            email: "wrong@example.com",
            password: "wrongpassword"
        )
        
        // Act & Assert
        do {
            _ = try await service.login(credentials: credentials)
            XCTFail("Expected login to throw error")
        } catch let error as LoginError {
            XCTAssertEqual(error, LoginError.invalidCredentials)
            XCTAssertEqual(error.localizedDescription, "Invalid email or password")
        } catch {
            XCTFail("Expected LoginError but got \(error)")
        }
    }
    
    func testLogin_WithServerErrorEmail_ThrowsServerError() async {
        // Arrange
        let credentials = UserCredentials(
            email: "error@example.com",
            password: "password123"
        )
        
        // Act & Assert
        do {
            _ = try await service.login(credentials: credentials)
            XCTFail("Expected login to throw error")
        } catch let error as LoginError {
            if case .serverError(let message) = error {
                XCTAssertEqual(message, "Internal server error")
            } else {
                XCTFail("Expected serverError but got \(error)")
            }
        } catch {
            XCTFail("Expected LoginError but got \(error)")
        }
    }
    
    // MARK: - Validation Tests
    
    func testLogin_WithInvalidEmailFormat_ThrowsInvalidEmailError() async {
        // Arrange
        let credentials = UserCredentials(
            email: "invalid-email",
            password: "password123"
        )
        
        // Act & Assert
        do {
            _ = try await service.login(credentials: credentials)
            XCTFail("Expected login to throw error")
        } catch let error as LoginError {
            XCTAssertEqual(error, LoginError.invalidEmail)
            XCTAssertEqual(error.localizedDescription, "Please enter a valid email address")
        } catch {
            XCTFail("Expected LoginError but got \(error)")
        }
    }
    
    func testLogin_WithEmptyPassword_ThrowsEmptyPasswordError() async {
        // Arrange
        let credentials = UserCredentials(
            email: "test@example.com",
            password: ""
        )
        
        // Act & Assert
        do {
            _ = try await service.login(credentials: credentials)
            XCTFail("Expected login to throw error")
        } catch let error as LoginError {
            XCTAssertEqual(error, LoginError.emptyPassword)
            XCTAssertEqual(error.localizedDescription, "Password cannot be empty")
        } catch {
            XCTFail("Expected LoginError but got \(error)")
        }
    }
    
    func testLogin_WithEmailMissingAtSymbol_ThrowsInvalidEmailError() async {
        // Arrange
        let credentials = UserCredentials(
            email: "testexample.com",
            password: "password123"
        )
        
        // Act & Assert
        do {
            _ = try await service.login(credentials: credentials)
            XCTFail("Expected login to throw error")
        } catch let error as LoginError {
            XCTAssertEqual(error, LoginError.invalidEmail)
        } catch {
            XCTFail("Expected LoginError but got \(error)")
        }
    }
    
    func testLogin_WithEmailMissingDomain_ThrowsInvalidEmailError() async {
        // Arrange
        let credentials = UserCredentials(
            email: "test@",
            password: "password123"
        )
        
        // Act & Assert
        do {
            _ = try await service.login(credentials: credentials)
            XCTFail("Expected login to throw error")
        } catch let error as LoginError {
            XCTAssertEqual(error, LoginError.invalidEmail)
        } catch {
            XCTFail("Expected LoginError but got \(error)")
        }
    }
    
    // MARK: - Async/Await Tests
    
    func testLogin_IsAsyncOperation() async throws {
        // Arrange
        let credentials = UserCredentials(
            email: "test@example.com",
            password: "password123"
        )
        let startTime = Date()
        
        // Act
        _ = try await service.login(credentials: credentials)
        
        // Assert - Verify it took at least 0.5 seconds (simulated network delay is 1 second)
        let duration = Date().timeIntervalSince(startTime)
        XCTAssertGreaterThan(duration, 0.5, "Login should have async delay")
    }
}
