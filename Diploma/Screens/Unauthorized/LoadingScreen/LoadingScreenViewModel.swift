import Foundation
import SwiftUI

protocol LoadingScreenViewModelProtocol {
//    func checkUserAuth() -> Bool
}

class LoadingScreenViewModel: ObservableObject, LoadingScreenViewModelProtocol {
    @Published var loaded = false
    
    
}
