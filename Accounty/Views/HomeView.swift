import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Entry.timestamp, order: .reverse) private var entries: [Entry]
    
    @Binding var username: String
    @State private var selectedEntry: Entry?

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
                Text("Select an item from the sidebar")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Accounty - Your Personal NAV Analyzer")
        .navigationSubtitle("Last updated just now")
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
