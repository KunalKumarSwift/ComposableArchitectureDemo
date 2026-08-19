//  MockTransactionProvider.swift
//
//  Stand-in for a real transactions service. See MockAccountProvider for
//  why this lives beside the feature rather than behind a network layer.
import Foundation
import RecentTransactionsWidgetInterface

/// In-memory ``RecentTransactionsFetching`` conformance returning fixture
/// data after a short simulated network delay.
struct MockTransactionProvider: RecentTransactionsFetching {
    func fetchRecent(accountId: String?, limit: Int) async throws -> [Transaction] {
        try await Task.sleep(nanoseconds: 400_000_000)
        let all: [Transaction] = [
            Transaction(id: "t1", merchantName: "Trader Joe's", amount: -54.12, date: .now, category: "Groceries", isPending: false),
            Transaction(id: "t2", merchantName: "Payroll Deposit", amount: 2_400.00, date: .now.addingTimeInterval(-86_400), category: "Income", isPending: false),
            Transaction(id: "t3", merchantName: "Coffee Shop", amount: -6.75, date: .now.addingTimeInterval(-3_600), category: "Dining", isPending: true),
        ]
        return Array(all.prefix(limit))
    }
}
