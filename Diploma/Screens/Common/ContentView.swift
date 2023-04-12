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
                .navigationViewStyle(.stack)
                .statusBar(hidden: true)
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
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
