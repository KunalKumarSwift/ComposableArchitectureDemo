//  AccountSummaryViewModel.swift
//
//  Owns all state, loading, and error handling for the Account Summary
//  widget. Cache-first: a failed refresh keeps the last-known accounts on
//  screen behind a staleness banner rather than clearing them (PRD §6.5).
import AccountSummaryWidgetInterface
import Foundation
import Observation

/// The Account Summary widget's self-contained state and business logic.
@Observable
@MainActor
public final class AccountSummaryViewModel {
    public private(set) var accounts: [Account] = []
    public private(set) var isLoading: Bool = false
    public private(set) var lastError: AccountSummaryError?
    public private(set) var lastUpdated: Date?

    /// Whether balances render as plain text or masked dots. Reads through
    /// to the shared ``SharedState/BalanceVisibility`` instance, so toggling
    /// it here is visible to any other widget holding the same instance
    /// (e.g. Recent Transactions).
    public var isBalanceRevealed: Bool {
        dependencies.balanceVisibility.isRevealed
    }

    private let dependencies: AccountSummaryDependencies

    /// - Parameter dependencies: The widget's only way to reach the outside world.
    public init(dependencies: AccountSummaryDependencies) {
        self.dependencies = dependencies
    }

    /// Loads accounts. On failure, keeps whatever accounts are already
    /// cached in state and surfaces ``lastError`` instead of clearing them.
    public func refresh() async {
        isLoading = true
        do {
            let accounts = try await dependencies.accountFetching.fetchAccounts()
            self.accounts = accounts
            self.lastUpdated = dependencies.now()
            self.lastError = nil
        } catch {
            self.lastError = error as? AccountSummaryError ?? .network
        }
        isLoading = false
    }

    /// Flips whether balances render as plain text or masked dots, for
    /// this widget and every other widget sharing the same
    /// ``SharedState/BalanceVisibility`` instance.
    public func toggleBalanceVisibility() {
        dependencies.balanceVisibility.toggle()
    }
}
