import SwiftUI

extension View {
    func bottomShadow() -> some View {
        shadow(color: Color.customBlack.opacity(0.15), radius: 4, x: 0, y: 4)
    }
    
    func topShadow() -> some View {
        shadow(color: Color.customBlack.opacity(0.15), radius: 10, x: 0, y: -4)
    }
}
