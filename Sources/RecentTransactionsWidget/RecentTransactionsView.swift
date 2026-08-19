//  RecentTransactionsView.swift
//
//  Renders the Recent Transactions widget's own loading/error/empty/
//  content states, independent of every other Home screen widget.
import ComposableArchitecture
import DesignSystem
import Foundation
import RecentTransactionsWidgetInterface
import SwiftUI

/// SwiftUI presentation of ``RecentTransactionsFeature``.
public struct RecentTransactionsView: View {
    private let store: StoreOf<RecentTransactionsFeature>

    /// - Parameter store: A store scoped to ``RecentTransactionsFeature``.
    public init(store: StoreOf<RecentTransactionsFeature>) {
        self.store = store
    }

    public var body: some View {
        WidgetCard(title: "Recent Activity") {
            VStack(alignment: .leading, spacing: 12) {
                if let error = store.lastError, !store.transactions.isEmpty {
                    StalenessBanner(asOf: store.lastUpdated ?? .now) {
                        store.send(.retryButtonTapped)
                    }
                }

                if store.isLoading && store.transactions.isEmpty {
                    SkeletonView(height: 40)
                    SkeletonView(height: 40)
                    SkeletonView(height: 40)
                } else if store.transactions.isEmpty {
                    if store.lastError != nil {
                        errorEmptyState
                    } else {
                        Text("No recent activity")
                            .font(.subheadline)
                            .foregroundStyle(BankingPalette.secondaryText)
                    }
                } else {
                    ForEach(store.transactions) { transaction in
                        TransactionRowView(transaction: transaction)
                    }
                }
            }
        }
        .task { await store.send(.task).finish() }
    }

    private var errorEmptyState: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Couldn't load recent activity")
                .font(.subheadline)
                .foregroundStyle(BankingPalette.secondaryText)
            Button("Retry") { store.send(.retryButtonTapped) }
                .font(.caption.weight(.semibold))
        }
    }
}
