import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showPositionConfirmation = false
    @State private var showEntryConfirmation = false
    @State private var statusMessage = ""

    var body: some View {
        VStack(spacing: 0) {
            headerSection
            
            Form {
                Section(header: Text("Data Management")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Positions Reset")
                            .font(.headline)
                        
                        Text("Permanently delete all monthly asset snapshots.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Button(role: .destructive) {
                            showPositionConfirmation = true
                        } label: {
                            Label("Reset All Positions", systemImage: "trash")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                    .padding(.vertical, 5)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Entries Reset")
                            .font(.headline)
                        
                        Text("Permanently delete all income and expense transactions.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Button(role: .destructive) {
                            showEntryConfirmation = true
                        } label: {
                            Label("Reset All Entries", systemImage: "trash")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                    .padding(.vertical, 5)
                }
                
                Section(header: Text("App Information")) {
                    LabeledContent("Version", value: "1.0.0")
                    LabeledContent("Database", value: "SwiftData (Local)")
                }
            }
            .formStyle(.grouped)
            
            if !statusMessage.isEmpty {
                Text(statusMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding()
                    .transition(.opacity)
            }
        }
        .navigationTitle("Settings")
        .confirmationDialog("Reset Positions?", isPresented: $showPositionConfirmation, titleVisibility: .visible) {
            Button("Delete All Positions", role: .destructive) { resetData(for: Position.self) }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will remove all monthly NAV snapshots.")
        }
        .confirmationDialog("Reset Entries?", isPresented: $showEntryConfirmation, titleVisibility: .visible) {
            Button("Delete All Entries", role: .destructive) { resetData(for: Entry.self) }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will remove all transaction history.")
        }
    }

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Settings")
                    .font(.largeTitle).bold()
                Text("Manage your data and preferences")
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
    }

    private func resetData<T: PersistentModel>(for model: T.Type) {
        do {
            try modelContext.delete(model: T.self)
            try modelContext.save()
            
            withAnimation {
                statusMessage = "Data successfully cleared."
            }
            
            NSSound(named: "Basso")?.play()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation { statusMessage = "" }
            }
        } catch {
            statusMessage = "Error: \(error.localizedDescription)"
        }
    }
}
