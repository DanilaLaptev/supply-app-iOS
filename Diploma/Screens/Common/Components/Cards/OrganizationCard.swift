import SwiftUI

struct OrganizationCard: View {
    let organizationModel: OrganizationModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            AsyncImage(imageUrl: URL(string: organizationModel.organiztionImageUrl)) {
                Color.customDarkGray
            }
                .aspectRatio(1 / 1, contentMode: .fill)
                .frame(width: 80, height: 80)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(organizationModel.title)
                    .font(.customSubtitle)
                    .foregroundColor(.customBlack)
                
                HStack {
                    Image.customMarker
                        .frame(width: 16, height: 16)
                        .foregroundColor(.customOrange)
                    Text(organizationModel.address.addressName ?? "－")
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

struct OrganizationCard_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationCard(organizationModel: .empty)
    }
}
