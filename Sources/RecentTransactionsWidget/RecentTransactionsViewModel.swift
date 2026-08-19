//  RecentTransactionsViewModel.swift
//
//  Owns loading, caching, and error handling for the last 5 transactions
//  shown on Home. Cache-first with a visible retry affordance on error
//  (PRD §6.5), independent of every other widget's state.
import Foundation
import Observation
import RecentTransactionsWidgetInterface

/// The Recent Transactions widget's self-contained state and business logic.
@Observable
@MainActor
public final class RecentTransactionsViewModel {
    public private(set) var transactions: [Transaction] = []
    public private(set) var isLoading: Bool = false
    public private(set) var lastError: RecentTransactionsError?
    public private(set) var lastUpdated: Date?

    /// Matches the "last 5" refresh policy from the widget inventory (PRD §5).
    private static let displayLimit: Int = 5

    private let dependencies: RecentTransactionsDependencies

    /// - Parameter dependencies: The widget's only way to reach the outside world.
    public init(dependencies: RecentTransactionsDependencies) {
        self.dependencies = dependencies
    }

    /// Loads recent transactions across all accounts. On failure, keeps
    /// whatever is already cached and surfaces ``lastError`` for a retry
    /// affordance instead of clearing the list.
    public func refresh() async {
        isLoading = true
        do {
            let transactions = try await dependencies.transactionFetching.fetchRecent(nil, Self.displayLimit)
            self.transactions = transactions
            self.lastUpdated = dependencies.now()
            self.lastError = nil
        } catch {
            self.lastError = error as? RecentTransactionsError ?? .network
        }
        isLoading = false
    }
}
