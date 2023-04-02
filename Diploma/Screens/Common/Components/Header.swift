import SwiftUI

struct Header: View {
    @Environment(\.presentationMode) private var presentation
    var title: String
    var tapExtra: (() -> ())? = nil
        
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            CustomButton(icon: .customBack, background: .customWhite, foreground: .customOrange, isCircleShape: true) {
                presentation.wrappedValue.dismiss()
            }
            .frame(width: 48)
            
            ScrollView(.horizontal, showsIndicators: true) {
                Text(title)
                    .font(.customTitle)
            }
            
            if tapExtra != nil {
                CustomButton(icon: .customExtra, background: .customWhite, foreground: .customOrange, isCircleShape: true)
                    .frame(width: 48)
                    .rotationEffect(.degrees(90))
                    .onTapGesture {
                        tapExtra?()
                    }
            }
        }
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(title: "Title")
        Header(title: "Title") {
            
        }
    }
}
