//  HomeScreenDependencies.swift
//
//  Aggregates each widget's own Dependencies struct and nothing else
//  (PRD §6.3) — Home never touches Account, Transaction, or Offer types
//  directly, only the opaque Dependencies bundles that carry them.
import AccountSummaryWidget
import Foundation
import OffersWidget
import QuickActionsWidget
import RecentTransactionsWidget
import SharedState

/// Everything the Home screen needs to construct its four widgets.
public struct HomeScreenDependencies: Sendable {
    public let accountSummary: AccountSummaryDependencies
    public let recentTransactions: RecentTransactionsDependencies
    public let quickActions: QuickActionsDependencies
    public let offers: OffersDependencies

    /// - Parameters:
    ///   - accountSummary: Dependencies for the Account Summary widget.
    ///   - recentTransactions: Dependencies for the Recent Transactions widget.
    ///   - quickActions: Dependencies for the Quick Actions widget, including
    ///     the app-supplied navigation closures (PRD §6.4).
    ///   - offers: Dependencies for the Offers widget.
    public init(
        accountSummary: AccountSummaryDependencies,
        recentTransactions: RecentTransactionsDependencies,
        quickActions: QuickActionsDependencies,
        offers: OffersDependencies
    ) {
        self.accountSummary = accountSummary
        self.recentTransactions = recentTransactions
        self.quickActions = quickActions
        self.offers = offers
    }
}

extension HomeScreenDependencies {
    /// Default dependencies for every widget, backed by in-memory fixture
    /// data. The app only ever needs to supply the three navigation
    /// closures Quick Actions delegates out to (PRD §6.4) — it never has
    /// to know about any widget's `Dependencies` type individually.
    /// - Parameters:
    ///   - onTransferTapped: Invoked when the Transfer button is tapped.
    ///   - onPayBillTapped: Invoked when the Pay Bill button is tapped.
    ///   - onDepositTapped: Invoked when the Deposit button is tapped.
    public static func live(
        onTransferTapped: @escaping @Sendable () -> Void,
        onPayBillTapped: @escaping @Sendable () -> Void,
        onDepositTapped: @escaping @Sendable () -> Void
    ) -> HomeScreenDependencies {
        // One shared instance handed to every widget that needs to mask
        // balances together — this is the one seam where two widgets'
        // Dependencies structs intentionally reference the same object.
        let balanceVisibility = BalanceVisibility()
        return HomeScreenDependencies(
            accountSummary: .live(balanceVisibility: balanceVisibility),
            recentTransactions: .live(balanceVisibility: balanceVisibility),
            quickActions: .live(
                onTransferTapped: onTransferTapped,
                onPayBillTapped: onPayBillTapped,
                onDepositTapped: onDepositTapped
            ),
            offers: .live()
        )
    }
}
