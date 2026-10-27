import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView().tabItem { Label("Inicio", systemImage: "house.fill") }
            BudgetView().tabItem { Label("Presupuesto", systemImage: "target") }
            StatisticsView().tabItem { Label("Estadísticas", systemImage: "chart.bar.fill") }
            APIView().tabItem { Label("API", systemImage: "globe") }
            CreditsView().tabItem { Label("Créditos", systemImage: "person.crop.circle") }
        }
        .tint(GastiStyle.accent)
        .preferredColorScheme(.dark)
    }
}

enum GastiStyle {
    static let background = Color(red: 5.0/255, green: 11.0/255, blue: 20.0/255)
    static let card = Color(red: 16.0/255, green: 26.0/255, blue: 42.0/255)
    static let accent = Color(red: 0, green: 0.9, blue: 0.66)
    static let muted = Color(red: 139.0/255, green: 154.0/255, blue: 175.0/255)
}

extension Double {
    var copCurrency: String {
        formatted(.currency(code: "COP").locale(Locale(identifier: "es_CO")))
    }
}
