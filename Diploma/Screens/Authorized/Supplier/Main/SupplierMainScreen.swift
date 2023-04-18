import SwiftUI

struct SupplierMainScreen: View {
    public static let tag = "SupplierMainScreen"
    @State var showEditProductScreen = false
    
    @StateObject private var tools = ViewManager.shared
    
    @State private var tagSelection: String? = nil
    @State private var showDeleteProductAlert = false
    @State private var showHideProductAlert = false

    var body: some View {
        VStack {
            NavigationLink("", destination: EditProductScreen(), tag: EditProductScreen.tag, selection: $tagSelection)
            NavigationLink("", destination: ProductScreen(model: .empty), tag: ProductScreen.tag, selection: $tagSelection)
            
            TagsGroup<ProductType>()
            .padding(.top, 8)
            .padding(.bottom, 16)
            ScrollView(.vertical, showsIndicators: false) {
                AddProductButton  {
                    tagSelection = EditProductScreen.tag
                    
                }
                .padding(.horizontal, 16)
                .alert(isPresented: $showHideProductAlert) {
                    Alert(
                        title: Text("Скрыть продукт"),
                        message: Text("Вы точно хотите скрыть выбранный продукт?"),
                        primaryButton: .default(Text("Скрыть")) {
                            // TODO: action
                        },
                        secondaryButton: .cancel(Text("Отмена"))
                    )
                }
                
                VStack {
                    ForEach(["Кефир, 1 литр", "Гречка", "Рис", "Яблоки, 1 кг", "Картофель", "Творог", "Сыр", "Томатная паста", "Котлеты"], id: \.self) { name in
                        SupplierProductCard(name: name) {
                            tagSelection = EditProductScreen.tag
                        } tapVisibilityButton : {
                            self.showHideProductAlert.toggle()
                        } tapDeletingButton: {
                            self.showDeleteProductAlert.toggle()
                        }
                        .onTapGesture { tagSelection = ProductScreen.tag }
                    }
                }
                .padding(.horizontal, 16)
                .alert(isPresented: $showDeleteProductAlert) {
                    Alert(
                        title: Text("Удалить продукт"),
                        message: Text("Вы точно хотите удалить выбранный продукт?"),
                        primaryButton: .destructive(Text("Удалить")) {
                            // TODO: action
                        },
                        secondaryButton: .cancel(Text("Отмена"))
                    )
                }
            }
        }
        .padding(.top, safeAreaEdgeInsets.top)
        .background(Color.customLightGray)
        .defaultScreenSettings()
        .onAppear {
            self.tools.bottomBarIsVisible = true
        }
    }
}

struct SupplierMainScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SupplierMainScreen()
        }
    }
}
