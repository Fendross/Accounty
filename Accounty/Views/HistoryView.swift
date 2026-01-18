import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Entry.timestamp, order: .reverse) private var allEntries: [Entry]
    
    @State private var searchText = ""
    @State private var sortOrder = [KeyPathComparator(\Entry.timestamp, order: .reverse)]
    @State private var selectedEntryID: Entry.ID?

    var filteredEntries: [Entry] {
        if searchText.isEmpty {
            return allEntries
        } else {
            return allEntries.filter { entry in
                entry.desc.localizedCaseInsensitiveContains(searchText) ||
                entry.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        Table(filteredEntries, selection: $selectedEntryID, sortOrder: $sortOrder) {
            TableColumn("Date", value: \.timestamp) { entry in
                Text(entry.month)
            }
            .width(60)

            TableColumn("Type", value: \.type) { entry in
                Text(entry.type)
                    .foregroundStyle(entry.type == "Income" ? .green : .red)
            }
            .width(60)

            TableColumn("Category", value: \.category).width(250)

            TableColumn("Description", value: \.desc).width(350)

            TableColumn("Amount", value: \.amount) { entry in
                formatAmount(entry)
            }
            .width(120)
            
            TableColumn("Notes", value: \.notes)
        }
        .navigationTitle("Transaction History")
        .searchable(text: $searchText, placement: .toolbar, prompt: "Enter category...")
        .toolbar {
            Button(role: .destructive, action: deleteSelected) {
                Label("Delete", systemImage: "trash")
            }
            .disabled(selectedEntryID == nil)
        }
    }

    private func formatAmount(_ entry: Entry) -> some View {
        Text("\(entry.currency) \(entry.amount, specifier: "%.2f")")
            .font(.system(.body, design: .monospaced))
            .frame(maxWidth: .infinity, alignment: .trailing)
    }

    private func deleteSelected() {
        guard let id = selectedEntryID else { return }
        if let entryToDelete = allEntries.first(where: { $0.id == id }) {
            modelContext.delete(entryToDelete)
            selectedEntryID = nil
        }
    }
}
