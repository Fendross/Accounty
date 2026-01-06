import SwiftUI
import SwiftData

struct MainMenuView: View {
    // Environment initialization.
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Entry.timestamp, order: .reverse) private var entries: [Entry]
    
    // Variables.
    @Binding var username: String
    
    var types: [String] = ["Income", "Expense"]
    @State var type: String = "Income"
    
    var categories: [String] = ["Placeholder", "Salary", "Taxes", "Entertainment", "Utilities", "Social Life"]
    @State var category: String = "Placeholder"
                                
    @State var desc: String
    @State var amount: String
    @State var notes: String

    // Main View.
    var body: some View {
        NavigationStack {
            Text("_Hello_, **\(username)**")
            
            Divider()
            
            NavigationLink("New Entry") {
                EntryView(
                    username: $username,
                    type: "",
                    category: "",
                    desc: "",
                    amount: "",
                    notes: ""
                )
            }
        }
    }
}
