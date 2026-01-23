import XCTest
@testable import LoginFeature

@MainActor
final class SplashViewModelTests: XCTestCase {
    
    // MARK: - Test Properties
    
    var viewModel: SplashViewModel!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        self.viewModel = SplashViewModel()
    }
    
    override func tearDown() {
        self.viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialState() {
        XCTAssertFalse(self.viewModel.shouldShowLogin)
    }
    
    // MARK: - Timer Tests
    
    func testStartTimerSetsShowLoginAfterDelay() async {
        // Given
        XCTAssertFalse(self.viewModel.shouldShowLogin)
        
        // When
        self.viewModel.startTimer()
        
        // Then - Should still be false immediately
        XCTAssertFalse(self.viewModel.shouldShowLogin)
        
        // Wait for 3.5 seconds (3 second timer + 0.5 buffer)
        try? await Task.sleep(nanoseconds: 3_500_000_000)
        
        // Then - Should be true after timer completes
        XCTAssertTrue(self.viewModel.shouldShowLogin)
    }
    
    func testStartTimerDoesNotSetShowLoginBeforeDelay() async {
        // Given
        XCTAssertFalse(self.viewModel.shouldShowLogin)
        
        // When
        self.viewModel.startTimer()
        
        // Wait for 1 second (less than 3 seconds)
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Then - Should still be false
        XCTAssertFalse(self.viewModel.shouldShowLogin)
    }
}
