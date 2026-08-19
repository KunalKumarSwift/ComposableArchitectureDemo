//  RecentTransactionsDependencies.swift
//
//  The widget's sole entry point into the outside world (PRD §6.3).
import Foundation
import RecentTransactionsWidgetInterface

/// Everything ``RecentTransactionsViewModel`` needs from the outside world.
public struct RecentTransactionsDependencies: Sendable {
    public let transactionFetching: any RecentTransactionsFetching
    public let now: @Sendable () -> Date

    /// - Parameters:
    ///   - transactionFetching: Provider used to load recent transactions.
    ///   - now: Clock used to stamp ``RecentTransactionsViewModel/lastUpdated``.
    public init(transactionFetching: any RecentTransactionsFetching, now: @escaping @Sendable () -> Date = { .now }) {
        self.transactionFetching = transactionFetching
        self.now = now
    }
}

extension RecentTransactionsDependencies {
    /// Default dependencies backed by in-memory fixture data. This demo has
    /// no real transactions service; a production app would swap this for
    /// dependencies backed by a provider calling CoreNetworking.
    public static func live() -> RecentTransactionsDependencies {
        RecentTransactionsDependencies(transactionFetching: MockTransactionProvider())
    }
}
