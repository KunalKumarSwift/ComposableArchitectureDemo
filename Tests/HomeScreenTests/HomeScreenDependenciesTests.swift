//  HomeScreenDependenciesTests.swift
//
//  HomeScreen holds no business logic of its own (PRD §6.1), so its only
//  contract worth testing is that it aggregates each widget's Dependencies
//  without dropping or mutating anything.
import AccountSummaryWidget
import AccountSummaryWidgetInterface
import OffersWidget
import OffersWidgetInterface
import QuickActionsWidget
import QuickActionsWidgetInterface
import RecentTransactionsWidget
import RecentTransactionsWidgetInterface
import Testing

@testable import HomeScreen

@MainActor
struct HomeScreenDependenciesTests {
    @Test
    func aggregatesEachWidgetsDependenciesUnchanged() async throws {
        var transferTapped = false
        let dependencies = HomeScreenDependencies(
            accountSummary: AccountSummaryDependencies(accountFetching: StubAccountFetching()),
            recentTransactions: RecentTransactionsDependencies(transactionFetching: StubTransactionFetching()),
            quickActions: QuickActionsDependencies(
                entitlements: StubEntitlements(),
                onTransferTapped: { transferTapped = true },
                onPayBillTapped: {},
                onDepositTapped: {}
            ),
            offers: OffersDependencies(offersFetching: StubOffersFetching())
        )

        let accounts = try await dependencies.accountSummary.accountFetching.fetchAccounts()
        #expect(accounts.map(\.id) == ["stub"])

        dependencies.quickActions.onTransferTapped()
        #expect(transferTapped)

        #expect(dependencies.quickActions.entitlements.availableActions() == [.transfer])
    }
}

private struct StubAccountFetching: AccountFetching {
    func fetchAccounts() async throws -> [Account] {
        [Account(id: "stub", displayName: "Stub", balance: 0, maskedNumber: "•••• 0000", asOf: .now)]
    }
}

private struct StubTransactionFetching: RecentTransactionsFetching {
    func fetchRecent(accountId: String?, limit: Int) async throws -> [Transaction] { [] }
}

private struct StubEntitlements: QuickActionsEntitlementProviding {
    func availableActions() -> [QuickActionKind] { [.transfer] }
}

private struct StubOffersFetching: OffersFetching {
    func fetchOffers() async throws -> [Offer] { [] }
}
