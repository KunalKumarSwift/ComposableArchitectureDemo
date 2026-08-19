//  RecentTransactionsClient.swift
//
//  TCA dependency wrapping RecentTransactionsFetching, mirroring
//  AccountSummaryClient's pattern.
import ComposableArchitecture
import Foundation
import RecentTransactionsWidgetInterface

/// TCA-dependency-friendly wrapper around ``RecentTransactionsFetching``.
@DependencyClient
public struct RecentTransactionsClient: Sendable {
    /// Fetches recent transactions. See ``RecentTransactionsFetching``.
    public var fetchRecent: @Sendable (_ accountId: String?, _ limit: Int) async throws -> [Transaction]
}

extension RecentTransactionsClient: DependencyKey {
    /// Live value delegates to a real provider. This demo uses an
    /// in-memory mock since there is no backing transactions service.
    public static let liveValue: RecentTransactionsClient = RecentTransactionsClient(
        fetchRecent: { accountId, limit in
            try await MockTransactionProvider().fetchRecent(accountId: accountId, limit: limit)
        }
    )
}

extension DependencyValues {
    public var recentTransactionsClient: RecentTransactionsClient {
        get { self[RecentTransactionsClient.self] }
        set { self[RecentTransactionsClient.self] = newValue }
    }
}
