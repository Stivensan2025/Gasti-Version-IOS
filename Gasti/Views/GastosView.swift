
import SwiftUI

struct GastosView: View {

    @State private var transactions: [Transaction] = []
    @State private var showingAddExpense = false

    private var expenses: [Transaction] {
        transactions
            .filter { $0.type == .expense }
            .sorted { $0.date > $1.date }
    }

    private var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                // Resumen de gastos
                VStack(alignment: .leading, spacing: 10) {
                    Text("Gastos registrados")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(totalExpenses.copCurrency)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(GastiStyle.accent)

                    Text("\(expenses.count) movimientos registrados")
                        .font(.caption)
                        .foregroundColor(GastiStyle.muted)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(GastiStyle.card)
                .cornerRadius(18)

                // Historial
                HStack {
                    Text("Historial de gastos")
                        .font(.headline)
                        .foregroundColor(.white)

                    Spacer()

                    Button {
                        showingAddExpense = true
                    } label: {
                        Label("Registrar", systemImage: "plus.circle.fill")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(GastiStyle.accent)
                    }
                }

                if expenses.isEmpty {
                    Spacer()

                    Image(systemName: "receipt")
                        .font(.system(size: 45))
                        .foregroundColor(GastiStyle.muted)

                    Text("Todavía no tienes gastos")
                        .foregroundColor(.white)
                        .font(.headline)

                    Text("Registra tu primer gasto para comenzar.")
                        .font(.caption)
                        .foregroundColor(GastiStyle.muted)

                    Spacer()
                } else {
                    List {
                        ForEach(expenses) { transaction in
                            HStack(spacing: 12) {

                                Image(systemName: "arrow.down.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.red)

                                VStack(alignment: .leading, spacing: 5) {
                                    Text(transaction.title)
                                        .foregroundColor(.white)
                                        .font(.subheadline.weight(.semibold))

                                    Text("\(transaction.category) • \(transaction.date.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.caption)
                                        .foregroundColor(GastiStyle.muted)
                                }

                                Spacer()

                                Text("-\(transaction.amount.copCurrency)")
                                    .foregroundColor(.red)
                                    .font(.subheadline.weight(.semibold))
                            }
                            .listRowBackground(GastiStyle.card)
                        }
                        .onDelete(perform: deleteExpenses)
                    }
                    .scrollContentBackground(.hidden)
                }

                Button {
                    showingAddExpense = true
                } label: {
                    Label("Registrar gasto", systemImage: "plus")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(GastiStyle.accent)
                        .cornerRadius(14)
                }
            }
            .padding()
            .background(GastiStyle.background.ignoresSafeArea())
            .navigationTitle("Gastos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .onAppear {
                loadTransactions()
            }
            .sheet(
                isPresented: $showingAddExpense,
                onDismiss: {
                    loadTransactions()
                }
            ) {
                AddTransactionView(initialType: .expense)
            }
        }
        .preferredColorScheme(.dark)
    }

    private func loadTransactions() {
        transactions = PersistenceService.shared.loadTransactions()
    }

    private func deleteExpenses(at offsets: IndexSet) {
        let ids = offsets.map { expenses[$0].id }

        for id in ids {
            PersistenceService.shared.deleteTransaction(id: id)
        }

        loadTransactions()
    }
}

