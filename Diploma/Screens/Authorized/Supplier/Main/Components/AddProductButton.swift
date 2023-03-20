import SwiftUI

struct AddProductButton: View {
    var onClick: (() -> ())? = nil
    
    var body: some View {
        Button {
            onClick?()
        } label: {
            HStack(alignment: .center, spacing: 8) {
                Image.customBox.frame(width: 24, height: 24)
                Text("Добавить новую позицию").font(.customStandard)
            }
            .padding(16)
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(Color.customWhite)
            .foregroundColor(.customOrange)
            .cornerRadius(8)
        }

    }
}

struct AddNewProductButton_Previews: PreviewProvider {
    static var previews: some View {
        AddProductButton()
    }
}
