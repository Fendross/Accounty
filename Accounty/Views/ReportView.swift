import SwiftUI
import SwiftData
import Charts

struct ReportView: View {
    @Query(sort: \Entry.date, order: .reverse) private var allEntries: [Entry]
    @Query(sort: \Position.month, order: .forward) private var allPositions: [Position]
    
    @State private var selectedMonth: String = ""

    var availableMonths: [String] {
        let months = allEntries.map { $0.month }
        return Array(Set(months)).sorted(by: >)
    }

    var monthlyEntries: [Entry] {
        allEntries.filter { $0.month == selectedMonth }
    }

    var totalEarned: Double {
        monthlyEntries.filter { $0.type == "Income" }.reduce(0) { $0 + $1.amount }
    }
    
    var totalSpent: Double {
        monthlyEntries.filter { $0.type == "Expense" }.reduce(0) { $0 + $1.amount }
    }

    var savingsRate: Double {
        guard totalEarned > 0 else { return 0.0 }
        let rate = ((totalEarned - totalSpent) / totalEarned) * 100
        return max(rate, 0.0)
    }

    var currentNAV: Double {
        let position = allPositions.first(where: { $0.month == selectedMonth })
        return (position?.bankAccount ?? 0) + (position?.brokerLiquidity ?? 0) + (position?.pensionFund ?? 0)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                headerSection

                if availableMonths.isEmpty && allPositions.isEmpty {
                    ContentUnavailableView("No Data Available",
                                         systemImage: "chart.bar.fill",
                                         description: Text("Start by adding entries or positions to see reports."))
                        .padding(.top, 100)
                } else {
                    HStack(spacing: 15) {
                        SummaryCard(title: "Earned", amount: totalEarned, color: .green, isPercentage: false)
                        SummaryCard(title: "Spent", amount: totalSpent, color: .red, isPercentage: false)
                        SummaryCard(title: "Balance", amount: totalEarned - totalSpent, color: .blue, isPercentage: false)
                        SummaryCard(title: "Savings Rate", amount: savingsRate, color: .orange, isPercentage: true)
                        SummaryCard(title: "Net Asset Value", amount: currentNAV, color: .primary, isPercentage: false)
                    }
                    .padding(.horizontal)
                    
                    HStack(alignment: .top, spacing: 20) {
                        categoryBarChart
                        incomeExpenseDonutChart
                    }
                    .padding(.horizontal)

                    netWorthLineChart
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            if selectedMonth.isEmpty {
                selectedMonth = availableMonths.first ?? ""
            }
        }
    }

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Financial Reports")
                    .font(.largeTitle).bold()
                Text("Analyze your income and spending habits")
                    .foregroundStyle(.secondary)
            }
            Spacer()
            
            Picker("Selected Month", selection: $selectedMonth) {
                ForEach(availableMonths, id: \.self) { month in
                    Text(month).tag(month)
                }
            }
            .frame(width: 250)
        }
        .padding(.horizontal)
    }

    private var categoryBarChart: some View {
        VStack(alignment: .leading) {
            Text("Spending by Category")
                .font(.headline)
                .padding(.bottom, 10)
            
            Chart(monthlyEntries.filter { $0.type == "Expense" }) { entry in
                BarMark(
                    x: .value("Category", entry.category),
                    y: .value("Amount", entry.amount)
                )
                .foregroundStyle(by: .value("Category", entry.category))
            }
            .frame(height: 300)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }

    private var incomeExpenseDonutChart: some View {
        VStack(alignment: .leading) {
            Text("Income vs Expenses")
                .font(.headline)
                .padding(.bottom, 10)
            
            Chart {
                SectorMark(
                    angle: .value("Amount", totalEarned),
                    innerRadius: .ratio(0.6),
                    angularInset: 2
                )
                .foregroundStyle(by: .value("Type", "Income"))

                SectorMark(
                    angle: .value("Amount", totalSpent),
                    innerRadius: .ratio(0.6),
                    angularInset: 2
                )
                .foregroundStyle(by: .value("Type", "Spent"))
            }
            .chartForegroundStyleScale([
                "Income": .green,
                "Spent": .red
            ])
            .frame(height: 300)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }

    private var netWorthLineChart: some View {
        VStack(alignment: .leading) {
            Text("Net Worth Evolution")
                .font(.headline)
                .padding(.bottom, 10)

            Chart {
                ForEach(allPositions) { position in
                    let totalValue = position.bankAccount + position.brokerLiquidity + position.pensionFund
                    
                    AreaMark(
                        x: .value("Month", position.month),
                        y: .value("Net Worth", totalValue)
                    )
                    .foregroundStyle(LinearGradient(colors: [.blue.opacity(0.3), .blue.opacity(0.0)], startPoint: .top, endPoint: .bottom))
                    .interpolationMethod(.catmullRom)

                    LineMark(
                        x: .value("Month", position.month),
                        y: .value("Net Worth", totalValue)
                    )
                    .foregroundStyle(.blue)
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    .interpolationMethod(.catmullRom)
                    
                    PointMark(
                        x: .value("Month", position.month),
                        y: .value("Net Worth", totalValue)
                    )
                    .foregroundStyle(.blue)
                }
            }
            .frame(height: 350)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

struct SummaryCard: View {
    let title: String
    let amount: Double
    let color: Color
    let isPercentage: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            Text(isPercentage ? "\(amount, specifier: "%.1f")%" : "EUR \(amount, specifier: "%.2f")")
                .font(.system(.title2, design: .monospaced))
                .bold()
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}
