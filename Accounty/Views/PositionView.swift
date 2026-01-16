import SwiftUI
import SwiftData

struct PositionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Position.month, order: .reverse) private var allPositions: [Position]
    
    @State private var selectedMonth: String = ""
    @State private var showSuccess: Bool = false
    
    @State private var bankInput: Double = 0.0
    @State private var brokerInput: Double = 0.0
    @State private var pensionInput: Double = 0.0

    private var selectableMonths: [String] {
        let calendar = Calendar.current
        let now = Date()
        let currentMonthIndex = calendar.component(.month, from: now)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        
        return (0..<currentMonthIndex).reversed().map { i in
            let date = calendar.date(byAdding: .month, value: -i, to: now) ?? now
            return formatter.string(from: date)
        }
    }

    private var currentPosition: Position? {
        allPositions.first { $0.month == selectedMonth }
    }

    var body: some View {
        VStack(spacing: 0) {
            headerSection
            
            Divider()

            if selectedMonth.isEmpty {
                ContentUnavailableView("Select a Month", systemImage: "calendar")
            } else {
                if let position = currentPosition {
                    editForm(for: position)
                        .id(position.month)
                } else {
                    createStateView
                }
            }
        }
        .navigationTitle("Net Asset Value")
        .onAppear {
            if selectedMonth.isEmpty {
                selectedMonth = selectableMonths.first ?? ""
            }
        }
    }

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Monthly Snapshot")
                    .font(.headline)
                Text("Update your global asset positions")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            
            Picker("Period:", selection: $selectedMonth) {
                ForEach(selectableMonths, id: \.self) { month in
                    Text(month).tag(month)
                }
            }
            .pickerStyle(.menu)
            .frame(width: 200)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
    }

    private func editForm(for position: Position) -> some View {
        Form {
            Section("Assets Breakdown") {
                TextField("Bank Account", value: $bankInput, format: .currency(code: "EUR"))
                TextField("Broker Liquidity", value: $brokerInput, format: .currency(code: "EUR"))
                TextField("Pension Fund", value: $pensionInput, format: .currency(code: "EUR"))
            }
            
            Section("Global Position") {
                LabeledContent("Calculated NAV") {
                    Text("EUR \(bankInput + brokerInput + pensionInput, specifier: "%.2f")")
                        .font(.system(.body, design: .monospaced))
                        .bold()
                        .foregroundStyle(.blue)
                }
            }
            
            VStack(alignment: .trailing) {
                Button(action: { saveChanges(to: position) }) {
                    HStack {
                        if showSuccess {
                            Image(systemName: "checkmark.circle.fill")
                                .transition(.scale.combined(with: .opacity))
                        }
                        Text(showSuccess ? "Changes Saved" : "Update Position")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(showSuccess ? .green : .accentColor)
                .controlSize(.large)
                
                if showSuccess {
                    Text("Database updated successfully")
                        .font(.caption)
                        .foregroundStyle(.green)
                        .transition(.opacity)
                }
            }
            .padding(.top, 10)
        }
        .formStyle(.grouped)
        .onAppear { loadDataIntoState(position) }
        .onChange(of: selectedMonth) { _, _ in
            if let p = currentPosition { loadDataIntoState(p) }
        }
    }

    private var createStateView: some View {
        ContentUnavailableView {
            Label("No Record for \(selectedMonth)", systemImage: "doc.badge.plus")
        } description: {
            Text("Create a position snapshot to track your net worth for this month.")
        } actions: {
            Button("Initialize Month") {
                createNewPosition()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }

    private func loadDataIntoState(_ position: Position) {
        bankInput = position.bankAccount
        brokerInput = position.brokerLiquidity
        pensionInput = position.pensionFund
    }

    private func createNewPosition() {
        let newPos = Position(month: selectedMonth)
        modelContext.insert(newPos)
        try? modelContext.save()
        loadDataIntoState(newPos)
    }

    private func saveChanges(to position: Position) {
        position.bankAccount = bankInput
        position.brokerLiquidity = brokerInput
        position.pensionFund = pensionInput
        
        try? modelContext.save()

        withAnimation(.spring()) {
            showSuccess = true
        }

        NSSound(named: "Glass")?.play()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                showSuccess = false
            }
        }
    }
}
