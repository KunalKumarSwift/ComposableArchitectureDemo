//  RecentTransactionsDependencies.swift
//
//  The widget's sole entry point into the outside world (PRD §6.3).
import Foundation
import RecentTransactionsWidgetInterface
import SharedState

/// Everything ``RecentTransactionsViewModel`` needs from the outside world.
public struct RecentTransactionsDependencies: Sendable {
    public let transactionFetching: any RecentTransactionsFetching
    public let now: @Sendable () -> Date
    public let balanceVisibility: BalanceVisibility

    /// - Parameters:
    ///   - transactionFetching: Provider used to load recent transactions.
    ///   - now: Clock used to stamp ``RecentTransactionsViewModel/lastUpdated``.
    ///   - balanceVisibility: Shared reveal/hide toggle. Pass the same
    ///     instance given to ``AccountSummaryDependencies`` so both widgets
    ///     mask amounts together; defaults to a private instance for
    ///     widgets tested in isolation.
    public init(
        transactionFetching: any RecentTransactionsFetching,
        now: @escaping @Sendable () -> Date = { .now },
        balanceVisibility: BalanceVisibility = BalanceVisibility()
    ) {
        self.transactionFetching = transactionFetching
        self.now = now
        self.balanceVisibility = balanceVisibility
    }
}

extension RecentTransactionsDependencies {
    /// Default dependencies backed by in-memory fixture data. This demo has
    /// no real transactions service; a production app would swap this for
    /// dependencies backed by a provider calling CoreNetworking.
    /// - Parameter balanceVisibility: Shared reveal/hide toggle supplied by
    ///   the composition root so it can be handed to other widgets too.
    public static func live(balanceVisibility: BalanceVisibility) -> RecentTransactionsDependencies {
        RecentTransactionsDependencies(transactionFetching: MockTransactionProvider(), balanceVisibility: balanceVisibility)
    }
}
