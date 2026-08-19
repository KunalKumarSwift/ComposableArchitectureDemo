//  RecentTransactionsView.swift
//
//  Renders the Recent Transactions widget's own loading/error/empty/
//  content states, independent of every other Home screen widget.
import DesignSystem
import Foundation
import RecentTransactionsWidgetInterface
import SwiftUI

/// SwiftUI presentation of ``RecentTransactionsViewModel``.
public struct RecentTransactionsView: View {
    @State private var viewModel: RecentTransactionsViewModel

    /// - Parameter dependencies: The widget's only way to reach the outside world.
    public init(dependencies: RecentTransactionsDependencies) {
        _viewModel = State(initialValue: RecentTransactionsViewModel(dependencies: dependencies))
    }

    public var body: some View {
        WidgetCard(title: "Recent Activity") {
            VStack(alignment: .leading, spacing: 12) {
                if viewModel.lastError != nil, !viewModel.transactions.isEmpty {
                    StalenessBanner(asOf: viewModel.lastUpdated ?? .now) {
                        Task { await viewModel.refresh() }
                    }
                }

                if viewModel.isLoading && viewModel.transactions.isEmpty {
                    SkeletonView(height: 40)
                    SkeletonView(height: 40)
                    SkeletonView(height: 40)
                } else if viewModel.transactions.isEmpty {
                    if viewModel.lastError != nil {
                        errorEmptyState
                    } else {
                        Text("No recent activity")
                            .font(.subheadline)
                            .foregroundStyle(BankingPalette.secondaryText)
                    }
                } else {
                    ForEach(viewModel.transactions) { transaction in
                        TransactionRowView(transaction: transaction)
                    }
                }
            }
        }
        .task { await viewModel.refresh() }
    }

    private var errorEmptyState: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Couldn't load recent activity")
                .font(.subheadline)
                .foregroundStyle(BankingPalette.secondaryText)
            Button("Retry") { Task { await viewModel.refresh() } }
                .font(.caption.weight(.semibold))
        }
    }
}
