import SwiftUI

struct ContentView: View {
    @AppStorage("username") private var username: String = ""

    var body: some View {
        Group {
            if username.isEmpty {
                LoginView(username: $username)
            } else {
                MainMenuView(username: $username)
                    .transition(.move(edge: .trailing))
            }
        }
    }
}
