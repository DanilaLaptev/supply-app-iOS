import SwiftUI

struct SupplierAdditionalInfoRow: View {
    let icon: Image
    let hintText: String
    let value: String
    
    var body: some View {
        HStack(alignment: .center,spacing: 4) {
            icon
                .foregroundColor(.customOrange)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(value).font(.customStandard)
                Text(hintText).font(.customHint)
            }
            Spacer()
        }
    }
}

struct SupplierAdditionalInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        SupplierAdditionalInfoRow(icon: .customFilter, hintText: "hint", value: "value")
    }
}
