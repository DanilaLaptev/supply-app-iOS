import SwiftUI

struct DropDownList: View {
    let placeholder: String
    var items: [String]
    @Binding var selected: String
    
    var body: some View {
        HStack(alignment: .center) {
            Text(placeholder).font(.customStandard).foregroundColor(.customDarkGray)
            Spacer()
            Picker(selection: $selected) {
                ForEach(items, id: \.self) {
                    Text($0)
                }
            } label: {
                Text("\(selected)").font(.customStandard).foregroundColor(.customOrange)
            }
            .accentColor(.customOrange)
        }
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing], 16)
        .padding([.top, .bottom], 8)
        .frame(height: 48)
        .background(Color.clear.cornerRadius(8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.customDarkGray, lineWidth: 1)
        )
    }
}

struct DropDown_Previews: PreviewProvider {
    @State static var selected = ""
    static var items = ["Точка питания", "Поставщик"]
    static var previews: some View {
        DropDownList(
            placeholder: "Выберите роль",
            items: items,
            selected: $selected
        )
        .padding()
    }
}
