import Foundation
import SwiftData

@Model
final class Entry {
    var uuid: UUID
    var timestamp: Date
    var type: String
    var category: String
    var desc: String
    var currency: String
    var amount: Double
    
    init(timestamp: Date, type: String, category: String, desc: String, amount: Double) {
        self.uuid = UUID()
        self.timestamp = timestamp
        self.type = type
        self.category = category
        self.desc = desc
        self.currency = "EUR"
        self.amount = amount
    }
}
