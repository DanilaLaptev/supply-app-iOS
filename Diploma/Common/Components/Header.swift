import SwiftUI

struct Header: View {
    var tapExtra: (() -> ())? = nil
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            CustomButton(icon: .customBack, background: .customWhite, foreground: .customOrange, isCircleShape: true)
                .frame(width: 48)
            
            ScrollView(.horizontal, showsIndicators: true) {
                Text("Название")
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
        Header()
        Header {
            
        }
    }
}
