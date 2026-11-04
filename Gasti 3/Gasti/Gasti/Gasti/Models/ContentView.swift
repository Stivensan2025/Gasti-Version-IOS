import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Inicio", systemImage: "house.fill")
                }

            BudgetView()
                .tabItem {
                    Label("Presupuesto", systemImage: "chart.pie.fill")
                }

            StatisticsView()
                .tabItem {
                    Label("Estadísticas", systemImage: "chart.bar.fill")
                }

            APIView()
                .tabItem {
                    Label("API", systemImage: "globe")
                }

            CreditsView()
                .tabItem {
                    Label("Créditos", systemImage: "person.2.fill")
                }
        }
    }
}
