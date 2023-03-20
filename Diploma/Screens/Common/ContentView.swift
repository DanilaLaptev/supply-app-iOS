import SwiftUI

struct ContentView: View {
    @StateObject private var viewTools = ViewTools()
    
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
                ForEach(viewTools.alertsList) { alertModel in
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
        .environmentObject(viewTools)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
