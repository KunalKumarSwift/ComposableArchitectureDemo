//  AccountFetching.swift
//
//  Contract the AccountSummaryWidget depends on to load account data.
//  A concrete provider (real accounts service, or a mock) is supplied by
//  whoever registers the widget's TCA dependency at the app boundary.
import Foundation

/// Fetches the current customer's accounts and balances.
public protocol AccountFetching: Sendable {
    /// - Returns: All accounts visible to the current customer.
    /// - Throws: ``AccountSummaryError`` on failure.
    func fetchAccounts() async throws -> [Account]
}
