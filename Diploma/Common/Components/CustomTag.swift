import SwiftUI

struct CustomTag: View {
    @State private var isSelected = true
    let icon: Image
    let name: String

    var body: some View {
        HStack(alignment: .center ,spacing: 4) {
            icon
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            Text(name).font(.customHint)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
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
        CustomTag(icon: .customBox, name: "marker")
    }
}
