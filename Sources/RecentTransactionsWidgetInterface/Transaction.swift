//  Transaction.swift
//
//  Value model shared between RecentTransactionsWidget and whatever
//  transactions data source backs it.
import Foundation

/// A single posted or pending transaction shown on the Home screen.
public struct Transaction: Equatable, Identifiable, Sendable {
    public let id: String
    public let merchantName: String
    public let amount: Decimal
    public let date: Date
    public let category: String
    public let isPending: Bool

    /// - Parameters:
    ///   - id: Stable transaction identifier.
    ///   - merchantName: Payee or merchant display name.
    ///   - amount: Signed amount; negative for debits, positive for credits.
    ///   - date: When the transaction occurred or posted.
    ///   - category: Coarse spending category (e.g. "Groceries").
    ///   - isPending: Whether the transaction has not yet posted.
    public init(id: String, merchantName: String, amount: Decimal, date: Date, category: String, isPending: Bool) {
        self.id = id
        self.merchantName = merchantName
        self.amount = amount
        self.date = date
        self.category = category
        self.isPending = isPending
    }
}
