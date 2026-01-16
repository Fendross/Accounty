import Foundation
import SwiftData

@Model
final class Position {
    @Attribute(.unique) var month: String
    var bankAccount: Double
    var brokerLiquidity: Double
    var pensionFund: Double
    
    var nav: Double {
        bankAccount + brokerLiquidity + pensionFund
    }
    
    init(month: String, bankAccount: Double = 0.0, brokerLiquidity: Double = 0.0, pensionFund: Double = 0.0) {
        self.month = month
        self.bankAccount = bankAccount
        self.brokerLiquidity = brokerLiquidity
        self.pensionFund = pensionFund
    }
}
