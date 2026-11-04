import Foundation

final class PersistenceService {
    static let shared = PersistenceService()

    private let transactionsKey = "gasti_transactions"
    private let budgetsKey = "gasti_budgets"

    private init() {}

    // MARK: - Movimientos

    func loadTransactions() -> [Transaction] {
        guard let data = UserDefaults.standard.data(
            forKey: transactionsKey
        ) else {
            return []
        }

        do {
            return try JSONDecoder().decode(
                [Transaction].self,
                from: data
            )
        } catch {
            print("Error al cargar movimientos: \(error)")
            return []
        }
    }

    func saveTransactions(_ transactions: [Transaction]) {
        do {
            let data = try JSONEncoder().encode(transactions)
            UserDefaults.standard.set(data, forKey: transactionsKey)
        } catch {
            print("Error al guardar movimientos: \(error)")
        }
    }

    func addTransaction(_ transaction: Transaction) {
        var transactions = loadTransactions()
        transactions.append(transaction)
        saveTransactions(transactions)
    }

    func deleteTransaction(id: UUID) {
        var transactions = loadTransactions()
        transactions.removeAll { $0.id == id }
        saveTransactions(transactions)
    }

    // MARK: - Presupuestos

    func loadBudgets() -> [Budget] {
        guard let data = UserDefaults.standard.data(
            forKey: budgetsKey
        ) else {
            return []
        }

        do {
            return try JSONDecoder().decode([Budget].self, from: data)
        } catch {
            print("Error al cargar presupuestos: \(error)")
            return []
        }
    }

    func saveBudgets(_ budgets: [Budget]) {
        do {
            let data = try JSONEncoder().encode(budgets)
            UserDefaults.standard.set(data, forKey: budgetsKey)
        } catch {
            print("Error al guardar presupuestos: \(error)")
        }
    }

    func addBudget(_ budget: Budget) {
        var budgets = loadBudgets()
        budgets.append(budget)
        saveBudgets(budgets)
    }

    func updateBudget(_ budget: Budget) {
        var budgets = loadBudgets()

        if let index = budgets.firstIndex(where: { $0.id == budget.id }) {
            budgets[index] = budget
        } else {
            budgets.append(budget)
        }

        saveBudgets(budgets)
    }

    func deleteBudget(id: UUID) {
        var budgets = loadBudgets()
        budgets.removeAll { $0.id == id }
        saveBudgets(budgets)
    }

    func saveBudget(_ budget: Budget) {
        updateBudget(budget)
    }

    func budgetForCurrentMonth() -> Budget {
        loadBudgets().first {
            $0.monthKey == Budget.currentMonthKey
        } ?? Budget()
    }
}
