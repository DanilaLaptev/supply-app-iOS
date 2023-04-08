import SwiftUI

struct EmptyView: View {
    var text: String = "Box is empty"
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image("unpacked box").resizable().frame(width: 240, height: 240)
            Text(text).font(.customTitle)
        }
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
