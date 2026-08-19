//  AccountSummaryView.swift
//
//  Renders the Account Summary widget's own loading/error/content states.
//  Owns and creates its view model from injected dependencies, and
//  triggers its own load on first appearance — HomeScreen never reaches
//  into this widget to kick off data fetching.
import AccountSummaryWidgetInterface
import DesignSystem
import Foundation
import SwiftUI

/// SwiftUI presentation of ``AccountSummaryViewModel``.
public struct AccountSummaryView: View {
    @State private var viewModel: AccountSummaryViewModel

    /// - Parameter dependencies: The widget's only way to reach the outside world.
    public init(dependencies: AccountSummaryDependencies) {
        _viewModel = State(initialValue: AccountSummaryViewModel(dependencies: dependencies))
    }

    public var body: some View {
        WidgetCard(title: "Accounts") {
            VStack(alignment: .leading, spacing: 12) {
                if viewModel.lastError != nil, !viewModel.accounts.isEmpty {
                    StalenessBanner(asOf: viewModel.lastUpdated ?? .now) {
                        Task { await viewModel.refresh() }
                    }
                }

                if viewModel.isLoading && viewModel.accounts.isEmpty {
                    SkeletonView(height: 44)
                    SkeletonView(height: 44)
                } else {
                    ForEach(viewModel.accounts) { account in
                        AccountRowView(account: account, isBalanceRevealed: viewModel.isBalanceRevealed)
                    }
                }

                Button(viewModel.isBalanceRevealed ? "Hide balances" : "Show balances") {
                    viewModel.toggleBalanceVisibility()
                }
                .font(.caption.weight(.semibold))
            }
        }
        .task { await viewModel.refresh() }
        .refreshable { await viewModel.refresh() }
    }
}
