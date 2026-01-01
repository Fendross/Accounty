import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var username: String = ""

    var body: some View {
        NavigationStack {
            Label {}
            icon: {
                Ellipse()
                    .fill(Color(red: 0.5568, green: 0.5137, blue: 0.3451, opacity: 0.5))
                    .frame(width: 70, height: 60, alignment: .center)
                    .overlay(Text("Accounty"))
            }
            Image("AccountyIcon")
            
            Divider()
            
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
                    amount: "",
                    notes: ""
                )
            }
        }
    }
}
