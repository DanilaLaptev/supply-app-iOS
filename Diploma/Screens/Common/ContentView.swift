import SwiftUI

struct ContentView: View {
    @StateObject private var alertsManager = AlertManager.shared
    @StateObject private var viewManager = ViewManager.shared
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                NavigationView {
                    StartLoadingScreen()
                }
                .statusBar(hidden: true)
                .navigationViewStyle(.stack)
            }
            
            VStack(spacing: 8) {
                ForEach(alertsManager.alertsList) { alertModel in
                    CustomAlert(alertModel)
                }
                .animation(.easeInOut)
                Spacer()
            }
            .padding(.top, safeAreaEdgeInsets.top)
            .clipped()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            LoaderView(isLoading: $viewManager.isLoading)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
