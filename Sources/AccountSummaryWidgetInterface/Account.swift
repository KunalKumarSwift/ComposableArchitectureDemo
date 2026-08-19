//  Account.swift
//
//  Value model shared between AccountSummaryWidget and whatever accounts
//  data source backs it. Interface-only: no networking, no persistence.
import Foundation

/// A single bank account and its balance, as shown on the Home screen.
public struct Account: Equatable, Identifiable, Sendable {
    public let id: String
    public let displayName: String
    public let balance: Decimal
    public let maskedNumber: String
    public let asOf: Date

    /// - Parameters:
    ///   - id: Stable account identifier.
    ///   - displayName: Human-readable account name (e.g. "Everyday Checking").
    ///   - balance: Current balance in the account's local currency.
    ///   - maskedNumber: Last-4-digits masked account number (e.g. "•••• 4821").
    ///   - asOf: Timestamp the balance was last known accurate.
    public init(id: String, displayName: String, balance: Decimal, maskedNumber: String, asOf: Date) {
        self.id = id
        self.displayName = displayName
        self.balance = balance
        self.maskedNumber = maskedNumber
        self.asOf = asOf
    }
}
