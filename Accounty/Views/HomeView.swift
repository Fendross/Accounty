import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Entry.timestamp, order: .reverse) private var entries: [Entry]
    
    @Binding var username: String
    @State private var selectedEntry: Entry?
    
    @State var type: String
    @State var category: String
    @State var desc: String
    @State var amount: String
    
    var types: [String] = ["Income", "Expense"]
    @State var selectedType: String = "Income"

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedEntry) {
                Text("_Hello_, **\(username)**")
                
                Divider()
                
                ForEach(entries) { entry in
                    NavigationLink(value: entry) {
                        Text(entry.toStringLabel())
                    }
                }
            }
            .navigationSplitViewColumnWidth(min: 200, ideal: 300)
            .toolbar {
                ToolbarItem {
                    Button(action: addEntry) {
                        Label("Add Entry", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button(action: deleteAllEntries) {
                        Label("Delete All Entries", systemImage: "minus")
                    }
                }
            }
        } detail: {
            if let selectedEntry {
                VStack {
                    Text(selectedEntry.toStringFull())
                    Spacer()
                }
                .padding()
            } else {
                VStack {
                    Text("New entry creation")
                    
                    Divider()
                    
                    Picker("Type", selection: $selectedType) {
                        ForEach(types, id: \.self) { type in
                            Text(type)
                        }
                    }
                    TextField(text: $type, prompt: Text("Enter typology...")) {
                        Text("Type")
                    }
                    .frame(width: 200, height: 50)
                    .textFieldStyle(.roundedBorder)
                    TextField(text: $category, prompt: Text("Enter category...")) {
                        Text("Category")
                    }
                    .frame(width: 200, height: 50)
                    .textFieldStyle(.roundedBorder)
                    TextField(text: $desc, prompt: Text("Enter description...")) {
                        Text("Description")
                    }
                    .frame(width: 200, height: 50)
                    .textFieldStyle(.roundedBorder)
                    TextField(text: $amount, prompt: Text("Enter amount...")) {
                        Text("Amount")
                    }
                    .frame(width: 200, height: 50)
                    .textFieldStyle(.roundedBorder)
                    Button(action: addEntry) {
                        Label("Insert", systemImage: "character.book.closed")
                    }
                }
            }
        }
        .navigationTitle("Accounty")
        .navigationSubtitle("Manage your finances")
    }
    
    private func addEntry() {
        withAnimation {
            let newEntry = Entry(
                timestamp: Date(),
                type: "EXPENSE",
                category: "Travel",
                desc: "Flight - CRL",
                amount: 100.99
            )
            modelContext.insert(newEntry)
        }
    }
    
    private func deleteAllEntries() {
        do {
            try modelContext.delete(model: Entry.self)
        } catch {
            print("Failed to delete students.")
        }
    }
}
