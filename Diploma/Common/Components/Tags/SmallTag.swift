import SwiftUI

struct SmallTag: View {
    let icon: Image
    let name: String
    @State var isSelected = false
    
    var body: some View {
        CustomTag(isSelected: $isSelected) {
            HStack(alignment: .center ,spacing: 4) {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(name).font(.customHint)
            }
        }
    }
}

struct SmallTag_Previews: PreviewProvider {
    static var previews: some View {
        SmallTag(icon: .customBox, name: "Box")
    }
}
