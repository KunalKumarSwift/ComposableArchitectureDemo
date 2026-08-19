//  RecentTransactionsFetching.swift
//
//  Contract the RecentTransactionsWidget depends on to load recent
//  activity. Accounts are combined (accountId: nil) by default per the
//  PRD's open question, resolved here in favor of a single combined feed.
import Foundation

/// Fetches recent transactions, optionally scoped to one account.
public protocol RecentTransactionsFetching: Sendable {
    /// - Parameters:
    ///   - accountId: Restrict to one account, or `nil` to combine all accounts.
    ///   - limit: Maximum number of transactions to return.
    /// - Returns: The most recent transactions, newest first.
    /// - Throws: ``RecentTransactionsError`` on failure.
    func fetchRecent(accountId: String?, limit: Int) async throws -> [Transaction]
}
