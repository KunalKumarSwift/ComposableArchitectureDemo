//  AccountSummaryView.swift
//
//  Renders the Account Summary widget's own loading/error/content states.
//  Triggers its own load on first appearance — HomeScreen never calls
//  into this widget to kick off data fetching.
import AccountSummaryWidgetInterface
import ComposableArchitecture
import DesignSystem
import Foundation
import SwiftUI

/// SwiftUI presentation of ``AccountSummaryFeature``.
public struct AccountSummaryView: View {
    private let store: StoreOf<AccountSummaryFeature>

    /// - Parameter store: A store scoped to ``AccountSummaryFeature``.
    public init(store: StoreOf<AccountSummaryFeature>) {
        self.store = store
    }

    public var body: some View {
        WidgetCard(title: "Accounts") {
            VStack(alignment: .leading, spacing: 12) {
                if let error = store.lastError, !store.accounts.isEmpty {
                    StalenessBanner(asOf: store.lastUpdated ?? .now) {
                        store.send(.refreshButtonTapped)
                    }
                    .accessibilityHint(errorDescription(error))
                }

                if store.isLoading && store.accounts.isEmpty {
                    SkeletonView(height: 44)
                    SkeletonView(height: 44)
                } else {
                    ForEach(store.accounts) { account in
                        AccountRowView(account: account, isBalanceRevealed: store.isBalanceRevealed)
                    }
                }

                Button(store.isBalanceRevealed ? "Hide balances" : "Show balances") {
                    store.send(.toggleBalanceVisibility)
                }
                .font(.caption.weight(.semibold))
            }
        }
        .task { await store.send(.task).finish() }
        .refreshable { await store.send(.refreshButtonTapped).finish() }
    }

    private func errorDescription(_ error: AccountSummaryError) -> String {
        switch error {
        case .network: return "Network error refreshing accounts."
        case .decoding: return "Could not read the latest account data."
        }
    }
}
