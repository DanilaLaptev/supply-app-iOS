import Foundation
import SwiftUI
import Combine

class LoadingScreenViewModel: ObservableObject {
    @Published var authManager = AuthManager.shared
    @Published var viewManager = ViewManager.shared
    
    @Published var nextScreenTag: String? = nil
    
    private var cancellableSet = Set<AnyCancellable>()
    
    private var isLoadingPublisher: AnyPublisher<Bool, Never> {
        $nextScreenTag
            .map { $0 == nil }
            .eraseToAnyPublisher()
    }
    
    init() {
//        isLoadingPublisher
//            .receive(on: RunLoop.main)
//            .assign(to: \.viewManager.isLoading, on: self)
//            .store(in: &cancellableSet)
    }
    
    func checkUserAuth() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            let authData = AuthData(userId: 1, token: "token", role: .supplier) // TODO: real data
            self?.authManager.setData(nil)
            self?.nextScreenTag = AuthorizationWrapper.tag
        }
    }
}
