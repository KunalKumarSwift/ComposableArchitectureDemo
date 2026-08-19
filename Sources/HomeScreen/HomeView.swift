//  HomeView.swift
//
//  Pure layout: stacks the four widget views in priority order (PRD §5).
//  Each widget view triggers its own load via its own `.task` — HomeView
//  never calls into a widget's actions directly, so a broken widget can
//  never block another's rendering or refresh.
import AccountSummaryWidget
import ComposableArchitecture
import OffersWidget
import QuickActionsWidget
import RecentTransactionsWidget
import SwiftUI

/// SwiftUI presentation of ``HomeFeature`` — composition only.
public struct HomeView: View {
    private let store: StoreOf<HomeFeature>

    /// - Parameter store: A store scoped to ``HomeFeature``.
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AccountSummaryView(store: store.scope(state: \.accountSummary, action: \.accountSummary))
                QuickActionsView(store: store.scope(state: \.quickActions, action: \.quickActions))
                RecentTransactionsView(store: store.scope(state: \.recentTransactions, action: \.recentTransactions))
                OffersView(store: store.scope(state: \.offers, action: \.offers))
            }
            .padding(16)
        }
        .navigationTitle("Home")
    }
}
