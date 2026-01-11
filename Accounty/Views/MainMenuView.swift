import SwiftUI
import SwiftData

struct MainMenuView: View {
    @Binding var username: String
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                VStack {
                    Spacer()
                    Text("_Hello_, **\(username)**")
                        .font(.system(size: 32))
                    Text("Select an action to manage your finances")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: 150, maxHeight: 200)

                VStack(spacing: 24) {
                    HStack(spacing: 24) {
                        DashboardButton(title: "New Entry", icon: "plus.square.fill", color: .blue) {
                            path.append("new_entry")
                        }
                        
                        DashboardButton(title: "Reports", icon: "chart.bar.xaxis", color: .green) {
                            path.append("reports")
                        }
                    }

                    HStack(spacing: 24) {
                        DashboardButton(title: "History", icon: "clock.arrow.circlepath", color: .purple) {
                            path.append("history")
                        }
                        
                        DashboardButton(title: "Settings", icon: "gearshape.fill", color: .gray) {
                            path.append("settings")
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .navigationDestination(for: String.self) { value in
                switch value {
                case "new_entry":
                    EntryView(
                        username: $username,
                        type: "",
                        category: "",
                        desc: "",
                        amount: "",
                        notes: ""
                    )
                case "reports":
                    Text("Automatic Reports View")
                case "history":
                    HistoryView()
                case "settings":
                    Text("Settings View")
                default:
                    Text("Unknown View")
                }
            }
        }
    }
}

struct DashboardButton: View {
    let title: String
    let icon: String
    let color: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 44))
                    .foregroundStyle(color)
                
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            .frame(width: 180, height: 180)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
