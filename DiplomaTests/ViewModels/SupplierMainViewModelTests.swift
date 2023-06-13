import XCTest
import Combine
import Moya
@testable import Diploma

final class SupplierMainViewModelTests: XCTestCase {
    
    var viewModel: SupplierMainViewModel!
    var organizationBranchServiceMock: OrganizationBranchService!

    override func setUp() {
        super.setUp()
        
        organizationBranchServiceMock = OrganizationBranchService(provider: MoyaProvider<OrganizationBranchProvider>(stubClosure: MoyaProvider.immediatelyStub))
        
        viewModel = SupplierMainViewModel(organizationBranchService: organizationBranchServiceMock)
    }
    
    override func tearDown() {
        viewModel = nil
        organizationBranchServiceMock = nil
        
        super.tearDown()
    }
    
    func testShowEditScreen() {
        // Arrange
        let expectation = XCTestExpectation(description: "Show edit screen")
        let product = StorageItemModel.empty
        var showEditScreenValue: Bool?
        
        // Act
        let cancellable = viewModel.$showEditScreen
            .sink { value in
                showEditScreenValue = value
            }
        
        viewModel.openEditView(product)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            expectation.fulfill()
        }

        // Assert
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(showEditScreenValue ?? false)
        
        cancellable.cancel()
    }

    func testShowProductScreen() {
        // Arrange
        let expectation = XCTestExpectation(description: "Open product screen")
        let product = StorageItemModel.empty
        var showProductScreenValue: Bool?
        
        // Act
        let cancellable = viewModel.$showProductScreen
            .sink { value in
                showProductScreenValue = value
            }
        
        viewModel.openProductView(product)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            expectation.fulfill()
        }
        
        // Assert
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(showProductScreenValue ?? false)
        
        cancellable.cancel()
    }

    // Пример асинхронного теста
    func testStorageItemsFetch() {
        // Arrange
        let expectation = XCTestExpectation(description: "Storage Items Fetch")
        var storageItemsValue: [StorageItemModel] = []
        
        let cancellable = viewModel.$storageItems
            .sink { value in
                storageItemsValue = value
                expectation.fulfill()
            }
        
        // Act
        viewModel.fetchStorageItems()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            expectation.fulfill()
        }
        
        // Assert
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(storageItemsValue.count, 2)
        
        cancellable.cancel()
    }
}
