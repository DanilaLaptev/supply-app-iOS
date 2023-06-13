@testable import Diploma

class UpdateBindingsProtocolMock: UpdateBindingsProtocol {
    var updateCalled = false
    
    func update() {
        updateCalled = true
    }
}

class NavigationProtocolMock: NavigationProtocol {
    var backCalled = false
    
    func back() {
        backCalled = true
    }
}
