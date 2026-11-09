import SwiftUI

struct ContentView: View {

    @AppStorage("gasti_is_logged_in")
    private var isLoggedIn = false

    @AppStorage("gasti_user_email")
    private var userEmail = ""

    var body: some View {
        Group {
            if isLoggedIn {
                mainTabs
            } else {
                LoginView { email in
                    userEmail = email
                    isLoggedIn = true
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var mainTabs: some View {
        TabView {

            HomeView()
                .tabItem {
                    Label("Inicio", systemImage: "house.fill")
                }

            BudgetView()
                .tabItem {
                    Label("Presupuesto", systemImage: "target")
                }

            StatisticsView()
                .tabItem {
                    Label("Estadísticas", systemImage: "chart.bar.fill")
                }

            GastosView()
                .tabItem {
                    Label("Gastos", systemImage: "plus.circle.fill")
                }

            CreditsView(onLogout: {
                // Cerrar la sesión local y volver al inicio de sesión.
                isLoggedIn = false
                userEmail = ""
            })
            .tabItem {
                Label("Perfil", systemImage: "person.crop.circle")
            }
        }
        .accentColor(GastiStyle.accent)
    }
}

enum GastiStyle {

    static let background = Color(
        red: 5.0 / 255,
        green: 11.0 / 255,
        blue: 20.0 / 255
    )

    static let card = Color(
        red: 16.0 / 255,
        green: 26.0 / 255,
        blue: 42.0 / 255
    )

    static let accent = Color(
        red: 0,
        green: 0.9,
        blue: 0.66
    )

    static let muted = Color(
        red: 139.0 / 255,
        green: 154.0 / 255,
        blue: 175.0 / 255
    )
}

extension Double {

    var copCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "COP"
        formatter.locale = Locale(identifier: "es_CO")
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0

        return formatter.string(from: NSNumber(value: self))
            ?? "$\(self)"
    }
}
