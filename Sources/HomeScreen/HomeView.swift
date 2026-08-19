//  HomeView.swift
//
//  Pure layout: stacks the four widget views in priority order (PRD §5).
//  Each widget view owns and loads its own view model — HomeView never
//  reaches into a widget's state, so a broken widget can never block
//  another's rendering or refresh.
import AccountSummaryWidget
import OffersWidget
import QuickActionsWidget
import RecentTransactionsWidget
import SwiftUI

/// SwiftUI presentation composing the four Home screen widgets — layout only.
public struct HomeView: View {
    private let dependencies: HomeScreenDependencies

    /// - Parameter dependencies: Aggregated dependencies for every widget.
    public init(dependencies: HomeScreenDependencies) {
        self.dependencies = dependencies
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AccountSummaryView(dependencies: dependencies.accountSummary)
                QuickActionsView(dependencies: dependencies.quickActions)
                RecentTransactionsView(dependencies: dependencies.recentTransactions)
                OffersView(dependencies: dependencies.offers)
            }
            .padding(16)
        }
        .navigationTitle("Home")
    }
}
