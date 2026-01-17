import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct ImportView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isImporting: Bool = false
    @State private var importStrategy: ImportStrategy = .append
    @State private var importMessage: String = ""
    @State private var showStatus: Bool = false

    enum ImportStrategy {
        case append, override
    }

    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 12) {
                Image(systemName: "square.and.arrow.down.on.square")
                    .font(.system(size: 48))
                    .foregroundStyle(.primary)
                
                Text("Import Data")
                    .font(.title2).bold()
                
                Text("Select a CSV file exported from Numbers")
                    .foregroundStyle(.secondary)
            }

            Form {
                Section("Settings") {
                    Picker("Method", selection: $importStrategy) {
                        Text("Append to existing").tag(ImportStrategy.append)
                        Text("Overwrite all entries").tag(ImportStrategy.override)
                    }
                    .pickerStyle(.radioGroup)
                }
            }
            .formStyle(.grouped)
            .frame(width: 350, height: 120)

            VStack(spacing: 15) {
                Button(action: { isImporting = true }) {
                    Label("Select CSV File", systemImage: "doc.text")
                        .frame(width: 180)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                if showStatus {
                    Text(importMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .transition(.opacity)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.commaSeparatedText],
            allowsMultipleSelection: false
        ) { result in
            handleImport(result: result)
        }
    }

    private func handleImport(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            
            if url.startAccessingSecurityScopedResource() {
                defer { url.stopAccessingSecurityScopedResource() }
                
                do {
                    let content = try String(contentsOf: url, encoding: .utf8)
                    processCSV(content)
                } catch {
                    updateStatus("Error reading file: \(error.localizedDescription)")
                }
            }
        case .failure(let error):
            updateStatus("File selection error: \(error.localizedDescription)")
        }
    }

    private func processCSV(_ content: String) {
        let rows = content.components(separatedBy: .newlines)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        var importedCount = 0
        let dateFormatter = ISO8601DateFormatter()

        if importStrategy == .override {
            try? modelContext.delete(model: Entry.self)
        }

        for (index, row) in rows.enumerated() {
            if index == 0 { continue }
            
            let columns = row.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            
            if columns.count >= 5 {
                let timestamp = dateFormatter.date(from: columns[0]) ?? Date()
                
                let amountString = columns[4].replacingOccurrences(of: " ", with: "")
                let amount = Double(amountString) ?? 0.0
                
                let newEntry = Entry(
                    timestamp: timestamp,
                    type: columns[1],
                    category: columns[2],
                    desc: columns[3],
                    amount: amount,
                    notes: columns.count > 5 ? columns[5] : ""
                )
                
                modelContext.insert(newEntry)
                importedCount += 1
            }
        }
        
        do {
            try modelContext.save()
            updateStatus("Successfully imported \(importedCount) entries.")
            NSSound(named: "Glass")?.play()
        } catch {
            updateStatus("Failed to save to database: \(error.localizedDescription)")
        }
    }

    private func updateStatus(_ message: String) {
        withAnimation {
            importMessage = message
            showStatus = true
        }
    }
}
