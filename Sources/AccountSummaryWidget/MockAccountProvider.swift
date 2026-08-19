//  MockAccountProvider.swift
//
//  Stand-in for a real accounts service so the widget is runnable and
//  testable without a backend. In a production app this file would be
//  replaced by a provider calling CoreNetworking against the real
//  Accounts service, still conforming to the same AccountFetching
//  protocol so nothing above this file changes.
import AccountSummaryWidgetInterface
import Foundation

/// In-memory ``AccountFetching`` conformance returning fixture data after
/// a short simulated network delay.
struct MockAccountProvider: AccountFetching {
    func fetchAccounts() async throws -> [Account] {
        try await Task.sleep(nanoseconds: 400_000_000)
        return [
            Account(id: "acc_checking", displayName: "Everyday Checking", balance: 4_218.42, maskedNumber: "•••• 4821", asOf: .now),
            Account(id: "acc_savings", displayName: "High-Yield Savings", balance: 12_930.07, maskedNumber: "•••• 1190", asOf: .now),
        ]
    }
}
