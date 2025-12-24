import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var entries: [Entry]
    
    @Binding var username: String

    var body: some View {
        HStack {
            NavigationSplitView {
                List {
                    Text("Welcome \(username)")
                }
                .navigationSplitViewColumnWidth(min: 180, ideal: 200)
                .toolbar {
                    ToolbarItem {
                        Button(action: helloWorlde) {
                            Label("Print Hello Worlde", systemImage: "checkmark.message")
                        }
                    }
                }
            } detail: {
                Text("Select an item from the sidebar")
            }
        }
        .buttonStyle(.bordered)
    }
    
    private func helloWorlde() {
        print("Hello World!")
    }
}

/*
 import SwiftUI
 import SwiftData

 struct ContentView: View {
     @Environment(\.modelContext) private var modelContext
     @Query private var items: [Item]

     var body: some View {
         NavigationSplitView {
             List {
                 ForEach(items) { item in
                     NavigationLink {
                         Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                     } label: {
                         Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                     }
                 }
                 .onDelete(perform: deleteItems)
             }
             .navigationSplitViewColumnWidth(min: 180, ideal: 200)
             .toolbar {
                 ToolbarItem {
                     Button(action: addItem) {
                         Label("Add Item", systemImage: "plus")
                     }
                 }
             }
         } detail: {
             Text("Select an item")
         }
     }

     private func addItem() {
         withAnimation {
             let newItem = Item(timestamp: Date())
             modelContext.insert(newItem)
         }
     }

     private func deleteItems(offsets: IndexSet) {
         withAnimation {
             for index in offsets {
                 modelContext.delete(items[index])
             }
         }
     }
 }

 #Preview {
     ContentView()
         .modelContainer(for: Item.self, inMemory: true)
 }

 */
