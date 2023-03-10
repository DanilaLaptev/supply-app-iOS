import SwiftUI

struct PlaceCard: View {
    private let name: String
    private let distance: Int
    private let openingTime: String

    init(name: String, distance: Int, openingTime: String) {
        self.name = name
        self.distance = distance
        self.openingTime = openingTime
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image("")
                .resizable()
                .aspectRatio(1 / 1, contentMode: .fill)
                .frame(width: 80, height: 80)
                .background(Color.customDarkGray)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text("Название продукта")
                    .font(.customSubtitle)
                    .foregroundColor(.customBlack)
                
                HStack {
                    Image.customMarker
                        .foregroundColor(.customOrange)
                    Text("0 ₽")
                        .font(.customHint)
                        .foregroundColor(.customDarkGray)
                }
                
                HStack {
                    Image.customClock
                        .foregroundColor(.customOrange)
                    Text("0 ₽")
                        .font(.customHint)
                        .foregroundColor(.customDarkGray)
                }
            }
            Spacer()
        }
        .padding(16)
        .background(Color.customWhite)
        .cornerRadius(8)
    }
}

struct PlaceCard_Previews: PreviewProvider {
    static var previews: some View {
        PlaceCard(name: "Магнит", distance: 20, openingTime: "10:00")
    }
}
