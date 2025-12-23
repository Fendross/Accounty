import SwiftUI
import SwiftData

struct EntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var entries: [Entry]
    
    @State private var username: String = ""

    var body: some View {
        TextField(
                "User name (email address)",
                text: $username
        )
        
        Text(username)
            .foregroundColor(false ? .red : .blue)
        
        HStack {
            Button("Sign In", systemImage: "arrow.up", action: helloWorld)
            Button("Logon", systemImage: "arrow.down", action: helloWorld)
        }
        .buttonStyle(.bordered)
    }
    
    private func helloWorld() {
        print("Hello World!")
    }
}


#Preview {
    EntryView()
        .modelContainer(for: Entry.self, inMemory: true)
}
