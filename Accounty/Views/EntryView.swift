import SwiftUI
import SwiftData

struct EntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Entry.timestamp, order: .reverse) private var allEntries: [Entry]
    
    @State private var selectedEntry: Entry?
    
    let types = ["Income", "Expense"]
    let categories = ["Salary", "Taxes", "Entertainment", "Utilities", "Social Life", "Food", "Travel"]
    
    // Form states.
    @State private var type: String = "Expense"
    @State private var category: String = "Entertainment"
    @State private var desc: String = ""
    @State private var amount: Double = 0.0
    @State private var notes: String = ""

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedEntry) {
                Section("Recent History") {
                    ForEach(allEntries) { entry in
                        NavigationLink(value: entry) {
                            VStack(alignment: .leading) {
                                Text(entry.desc.isEmpty ? "No Description" : entry.desc)
                                    .font(.headline)
                                Text(entry.toStringLabel())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationSplitViewColumnWidth(min: 250, ideal: 300)
            .toolbar {
                ToolbarItemGroup {
                    Button(action: resetSelectedEntry) {
                        Label("New Entry", systemImage: "plus.square")
                    }
                    Button(role: .destructive, action: deleteSelectedEntry) {
                        Label("Delete", systemImage: "trash")
                    }
                    .disabled(selectedEntry == nil)
                }
            }
        } detail: {
            if let selectedEntry {
                EntryDetailDisplay(entry: selectedEntry)
            } else {
                HStack {
                    Spacer()
                    
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 20) {
                            Text("New Entry")
                                .font(.largeTitle)
                                .bold()
                            
                            Form {
                                Section {
                                    Picker("Type", selection: $type) {
                                        ForEach(types, id: \.self) { Text($0) }
                                    }
                                    .pickerStyle(.segmented)
                                    
                                    Picker("Category", selection: $category) {
                                        ForEach(categories, id: \.self) { Text($0) }
                                    }
                                    
                                    TextField("Description", text: $desc)
                                    
                                    
                                    TextField("Amount", value: $amount, format: .currency(code: "EUR"))
                                }
                                
                                Section("Notes") {
                                    TextEditor(text: $notes)
                                        .frame(height: 80)
                                        .cornerRadius(5)
                                }
                            }
                            .formStyle(.grouped)
                            .frame(width: 400)
                            
                            Button(action: addEntry) {
                                Text("Insert Entry")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .frame(width: 400)
                        }
                        .padding(30)
                        .background(Color(NSColor.windowBackgroundColor))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .background(Color(NSColor.underPageBackgroundColor))
            }
        }
    }

    private func addEntry() {
        withAnimation {
            let newEntry = Entry(
                timestamp: Date(),
                type: type,
                category: category,
                desc: desc,
                amount: amount,
                notes: notes
            )
            modelContext.insert(newEntry)
            clearForm()
        }
    }
    
    private func clearForm() {
        desc = ""
        amount = 0.0
        notes = ""
    }

    private func deleteSelectedEntry() {
        if let entry = selectedEntry {
            modelContext.delete(entry)
            resetSelectedEntry()
        }
    }

    private func resetSelectedEntry() {
        selectedEntry = nil
    }
    
    private func deleteAllEntries() {
        try? modelContext.delete(model: Entry.self)
        resetSelectedEntry()
    }
}

struct EntryDetailDisplay: View {
    let entry: Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(entry.category)
                    .font(.title)
                    .bold()
                Spacer()
                Text("\(entry.currency) \(entry.amount, specifier: "%.2f")")
                    .font(.title)
                    .foregroundStyle(entry.type == "Income" ? .green : .red)
            }
            
            Divider()
            
            Group {
                Label(entry.timestamp.formatted(), systemImage: "calendar")
                Label(entry.type, systemImage: "info.circle")
            }
            .foregroundStyle(.secondary)
            
            Text("Description")
                .font(.headline)
            Text(entry.desc.isEmpty ? "No description provided." : entry.desc)
            
            Text("Notes")
                .font(.headline)
            Text(entry.notes.isEmpty ? "No notes." : entry.notes)
                .italic()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Entry Details")
    }
}
