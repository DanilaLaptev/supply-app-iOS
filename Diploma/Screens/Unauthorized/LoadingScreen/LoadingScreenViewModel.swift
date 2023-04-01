import Foundation
import SwiftUI
import Combine

class LoadingScreenViewModel: ObservableObject {
    @Published var authManager = AuthManager.shared
    
    @Published var nextScreenTag: String? = nil
    @Published var isLoading = true
    
    private var cancellableSet = Set<AnyCancellable>()
    
    private var isLoadingPublisher: AnyPublisher<Bool, Never> {
        $nextScreenTag
            .map { nextScreen in
                nextScreen == nil
            }
            .eraseToAnyPublisher()
    }
    
    init() {
        isLoadingPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellableSet)
    }
    
    
    func checkUserAuth() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            let authData = AuthData(userId: 1, token: "token") // TODO: real data
            self?.authManager.setData(authData)
            self?.nextScreenTag = AuthorizationWrapper.tag
        }
    }
}
