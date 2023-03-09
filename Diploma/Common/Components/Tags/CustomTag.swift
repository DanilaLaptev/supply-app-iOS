import SwiftUI

struct CustomTag<TagBody: View>: View {
    @Binding var isSelected: Bool
    let content: TagBody
    
    init(isSelected: Binding<Bool>, @ViewBuilder content: () -> TagBody) {
        self._isSelected = isSelected
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(8)
            .background(isSelected ? Color.customLightOrange : Color.customWhite)
            .foregroundColor(isSelected ? Color.customOrange : Color.customBlack)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.customDarkGray, lineWidth: isSelected ? 0 : 1)
            )
            .onTapGesture {
                isSelected.toggle()
            }
    }
}

struct CustomTag_Previews: PreviewProvider {
    static var previews: some View {
        CustomTag(isSelected: .constant(false)) {
            
        }
    }
}
