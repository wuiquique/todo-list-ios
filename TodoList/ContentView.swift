import SwiftUI

struct ContentView: View {
    @AppStorage("userId") var currentUserId: Int?
    @AppStorage("name") var currentName: String?
    @AppStorage("username") var currentUsername: String?
    
    var body: some View {
        NavigationView {
            if currentUsername != nil && currentUserId != nil && currentName != nil {
                Home()
            } else {
                Login()
            }
        }
    }
}

#Preview {
    ContentView()
}

