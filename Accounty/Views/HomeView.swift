import SwiftUI
import SwiftData

struct HomeView: View {
    // Environment initialization.
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Entry.timestamp, order: .reverse) private var entries: [Entry]
    
    // Variables.
    @Binding var username: String
    @State private var selectedEntry: Entry?
    
    var types: [String] = ["Income", "Expense"]
    @State var type: String = "Income"
    
    var categories: [String] = ["Placeholder", "Salary", "Taxes", "Entertainment", "Utilities", "Social Life"]
    @State var category: String = "Placeholder"
                                
    @State var desc: String
    @State var amount: String
    @State var notes: String

    // Main View.
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
            .navigationSplitViewColumnWidth(min: 400, ideal: 500)
            .toolbar {
                ToolbarItem {
                    Button(action: addEntry) {
                        Label("Add Entry", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button(action: deleteAllEntries) {
                        Label("Delete Entries", systemImage: "minus")
                    }
                }
                ToolbarItem {
                    Button(action: deleteSelectedEntry) {
                        Label("Delete Entry", systemImage: "minus.magnifyingglass")
                    }
                }
                ToolbarItem {
                    Button(action: resetSelectedEntry) {
                        Label("Unselect Entry", systemImage: "delete.left")
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
                    Text("New entry creation form")
                        .frame(width: 200, height: 50)
                        .textFieldStyle(.roundedBorder)
                    
                    Divider()
                    
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) { type in
                            Text(type)
                        }
                    }
                    .frame(width: 200, height: 50)
                    .textFieldStyle(.roundedBorder)
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
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
                    
                    TextField(text: $notes, prompt: Text("Enter notes on this entry...")) {
                        Text("Notes")
                    }
                    .frame(width: 200, height: 50)
                    .textFieldStyle(.roundedBorder)
                    
                    Button(action: addEntry) {
                        Label("Insert Entry", systemImage: "character.book.closed")
                    }
                }
            }
        }
        .navigationTitle("Accounty")
        .navigationSubtitle("Manage your finances")
    }
    
    // Methods.
    private func addEntry() {
        let convertedAmount: Double = Double(amount) ?? 0.0
        
        withAnimation {
            let newEntry = Entry(
                timestamp: Date(),
                type: type,
                category: category,
                desc: desc,
                amount: convertedAmount,
                notes: notes
            )
            modelContext.insert(newEntry)
        }
    }
    
    private func deleteAllEntries() {
        do {
            try modelContext.delete(model: Entry.self)
            resetSelectedEntry()
        } catch {
            print("Failed to delete entries.")
        }
    }
    
    private func deleteSelectedEntry() {
        if let unwrappedEntry = selectedEntry {
            modelContext.delete(unwrappedEntry)
            resetSelectedEntry()
        } else {
            return
        }
    }
    
    private func resetSelectedEntry() {
        selectedEntry = nil
    }
}
