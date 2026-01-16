import SwiftUI

struct LoginView: View {
    @Binding var username: String
    @State private var inputName: String = ""

    var body: some View {
        VStack(spacing: 30) {
            VStack {
                Ellipse()
                    .fill(Color(red: 0.5568, green: 0.5137, blue: 0.3451, opacity: 0.5))
                    .frame(width: 80, height: 70)
                    .overlay(Text("Accounty").bold())
                
                Text("Welcome to Accounty")
                    .font(.title)
                    .padding(.top, 10)
            }
            
            Divider().frame(width: 300)
            
            VStack(spacing: 15) {
                TextField("Username", text: $inputName, prompt: Text("Enter username..."))
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 250)
                    .onSubmit { login() }
                
                Button(action: login) {
                    Text("Login")
                        .frame(width: 230)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(inputName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .frame(minWidth: 500, minHeight: 400)
    }

    private func login() {
        withAnimation {
            username = inputName
        }
    }
}
