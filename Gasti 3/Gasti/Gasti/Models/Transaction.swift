import Foundation

enum TransactionType: String, Codable, CaseIterable, Identifiable {
    case income = "Ingreso"
    case expense = "Gasto"

    var id: String { rawValue }
}

struct Transaction: Identifiable, Codable {
    var id: UUID
    var title: String
    var amount: Double
    var typeRawValue: String
    var date: Date
    var category: String

    var type: TransactionType {
        get { TransactionType(rawValue: typeRawValue) ?? .expense }
        set { typeRawValue = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        title: String,
        amount: Double,
        type: TransactionType,
        date: Date = .now,
        category: String
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.typeRawValue = type.rawValue
        self.date = date
        self.category = category
    }
}
