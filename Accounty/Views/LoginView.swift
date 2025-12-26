import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var username: String = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField(text: $username, prompt: Text("Enter username...")) {
                    Text("Username")
                }
                .frame(width: 200, height: 50)
                .textFieldStyle(.roundedBorder)
            }
            NavigationLink("Login") {
                HomeView(
                    username: $username,
                    type: "",
                    category: "",
                    desc: "",
                    amount: ""
                )
            }
        }
    }
}
