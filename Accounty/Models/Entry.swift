import Foundation
import SwiftData

@Model
final class Entry {
    var date: Date
    var type: String
    var category: String
    var desc: String
    var currency: String = "EUR"
    var amount: Double
    var notes: String
    
    init(date: Date = .now, type: String = "Expense", category: String = "General", desc: String = "", amount: Double = 0.0, notes: String = "") {
        self.date = date
        self.type = type
        self.category = category
        self.desc = desc
        self.amount = amount
        self.notes = notes
    }

    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    var month: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }

    func toStringFull() -> String {
        "\(dateString) - \(type) - \(category) - \(desc) - \(currency) \(String(format: "%.2f", amount)) - \(notes)"
    }
    
    func toStringLabel() -> String {
        "\(dateString) - \(category) - \(currency)\(String(format: "%.2f", amount))"
    }
}
