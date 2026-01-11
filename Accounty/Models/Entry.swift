import Foundation
import SwiftData

@Model
final class Entry {
    var timestamp: Date
    var type: String
    var category: String
    var desc: String
    var currency: String = "EUR"
    var amount: Double
    var notes: String
    
    init(timestamp: Date = .now, type: String = "Expense", category: String = "General", desc: String = "", amount: Double = 0.0, notes: String = "") {
        self.timestamp = timestamp
        self.type = type
        self.category = category
        self.desc = desc
        self.amount = amount
        self.notes = notes
    }

    var month: String {
        timestamp.formatted(.dateTime.month().year())
    }

    func toStringFull() -> String {
        "\(timestamp.ISO8601Format()) - \(type) - \(category) - \(desc) - \(currency) \(String(format: "%.2f", amount)) - \(notes)"
    }
    
    func toStringLabel() -> String {
        "\(timestamp.formatted(date: .abbreviated, time: .omitted)) - \(category) - \(currency)\(String(format: "%.2f", amount))"
    }
}
