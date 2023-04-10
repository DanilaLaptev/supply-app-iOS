import SwiftUI

struct BigTag: View {
    let icon: Image
    let name: String
    @State var isSelected = false
    
    var body: some View {
        CustomTag(isSelected: isSelected) {
            VStack(alignment: .center ,spacing: 4) {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                Text(name).font(.customHint)
            }
            .aspectRatio(1 / 1, contentMode: .fit)
        }
    }
}

struct BigTag_Previews: PreviewProvider {
    static var previews: some View {
        BigTag(icon: .customBox, name: "Напитки")
    }
}
