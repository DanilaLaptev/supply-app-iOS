import XCTest
import Combine
import Moya
@testable import Diploma

class EditProductViewModelTests: XCTestCase {
    var viewModel: EditProductViewModel!
    var organizationBranchService: OrganizationBranchServiceProtocol!
    var updateBindingsMock: UpdateBindingsProtocolMock!
    var navigationMock: NavigationProtocolMock!
    
    override func setUp() {
        super.setUp()
        organizationBranchService = OrganizationBranchService(provider: MoyaProvider<OrganizationBranchProvider>(stubClosure: MoyaProvider.immediatelyStub))
        updateBindingsMock = UpdateBindingsProtocolMock()
        navigationMock = NavigationProtocolMock()
        
        viewModel = EditProductViewModel(
            organizationBranchService: organizationBranchService
        )
        viewModel.updateBindings = updateBindingsMock
        viewModel.navigation = navigationMock
    }
    
    override func tearDown() {
        organizationBranchService = nil
        updateBindingsMock = nil
        navigationMock = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testDescriptionValidation_EmptyDescription() {
        // Arrange
        let expectation = XCTestExpectation(description: "Description validation expectation")
        viewModel.description = ""
        
        // Act
        let cancellable = viewModel.isDescriptionValid.sink(receiveValue: { validationError in
            // Assert
            XCTAssertEqual(validationError, FormError.requiredField(source: "Описание").localizedDescription)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 2.0)
        
        cancellable.cancel()
    }
    
    func testPriceValidation_EmptyPrice() {
        // Arrange
        let expectation = XCTestExpectation(description: "Price validation expectation")
        viewModel.price = ""
        
        // Act
        let cancellable = viewModel.isPriceValid.sink(receiveValue: { validationError in
            // Assert
            XCTAssertEqual(validationError, FormError.requiredField(source: "Цена").localizedDescription)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 1.0)
        
        cancellable.cancel()
    }
    
    func testPriceValidation_InvalidPriceFormat() {
        // Arrange
        let expectation = XCTestExpectation(description: "Price validation expectation")
        viewModel.price = "abc"
        
        // Act
            let cancellable = viewModel.isPriceValid.sink(receiveValue: { validationError in
                // Assert
                XCTAssertEqual(validationError, FormError.wrongFormat(source: "Цена").localizedDescription)
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 1.0)
        
        cancellable.cancel()
    }
    
    func testUpdateStorageItem_SuccessfulRequest() {
        // Arrange
        let expectation = XCTestExpectation(description: "Update storage item expectation")
        
        // Act
        self.viewModel.updateStorageItem()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        // Assert
        XCTAssertTrue(self.updateBindingsMock.updateCalled)
        XCTAssertTrue(self.navigationMock.backCalled)
    }
}

