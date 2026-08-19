//  SharedBalanceVisibilityTests.swift
//
//  Proves the cross-widget sharing pattern actually works: two widgets
//  built from Dependencies structs that reference the same
//  BalanceVisibility instance observe each other's toggle, with neither
//  widget importing the other.
import AccountSummaryWidget
import AccountSummaryWidgetInterface
import RecentTransactionsWidget
import RecentTransactionsWidgetInterface
import SharedState
import Testing

@MainActor
struct SharedBalanceVisibilityTests {
    @Test
    func togglingInAccountSummaryIsReflectedInRecentTransactions() async {
        let balanceVisibility = BalanceVisibility()
        let accountSummary = AccountSummaryViewModel(
            dependencies: AccountSummaryDependencies(
                accountFetching: StubAccountFetching(),
                balanceVisibility: balanceVisibility
            )
        )
        let recentTransactions = RecentTransactionsViewModel(
            dependencies: RecentTransactionsDependencies(
                transactionFetching: StubTransactionFetching(),
                balanceVisibility: balanceVisibility
            )
        )

        #expect(accountSummary.isBalanceRevealed)
        #expect(recentTransactions.isBalanceRevealed)

        accountSummary.toggleBalanceVisibility()

        #expect(accountSummary.isBalanceRevealed == false)
        #expect(recentTransactions.isBalanceRevealed == false)
    }

    @Test
    func widgetsWithoutASharedInstanceDoNotAffectEachOther() async {
        let accountSummary = AccountSummaryViewModel(
            dependencies: AccountSummaryDependencies(accountFetching: StubAccountFetching())
        )
        let recentTransactions = RecentTransactionsViewModel(
            dependencies: RecentTransactionsDependencies(transactionFetching: StubTransactionFetching())
        )

        accountSummary.toggleBalanceVisibility()

        #expect(accountSummary.isBalanceRevealed == false)
        #expect(recentTransactions.isBalanceRevealed)
    }
}

private struct StubAccountFetching: AccountFetching {
    func fetchAccounts() async throws -> [Account] { [] }
}

private struct StubTransactionFetching: RecentTransactionsFetching {
    func fetchRecent(accountId: String?, limit: Int) async throws -> [Transaction] { [] }
}
