//  RecentTransactionsViewModelTests.swift
//
//  Independent test coverage for the Recent Transactions widget.
import Foundation
import RecentTransactionsWidgetInterface
import Testing

@testable import RecentTransactionsWidget

@MainActor
struct RecentTransactionsViewModelTests {
    @Test
    func refreshSucceedsAndPopulatesTransactions() async {
        let fixedDate = Date(timeIntervalSince1970: 0)
        let transaction = Transaction(id: "1", merchantName: "Coffee", amount: -5, date: fixedDate, category: "Dining", isPending: false)
        let viewModel = RecentTransactionsViewModel(
            dependencies: RecentTransactionsDependencies(
                transactionFetching: StubTransactionFetching(result: .success([transaction])),
                now: { fixedDate }
            )
        )

        await viewModel.refresh()

        #expect(viewModel.transactions == [transaction])
        #expect(viewModel.lastUpdated == fixedDate)
        #expect(viewModel.lastError == nil)
    }

    @Test
    func refreshFailureSetsErrorWithoutCachedData() async {
        let viewModel = RecentTransactionsViewModel(
            dependencies: RecentTransactionsDependencies(
                transactionFetching: StubTransactionFetching(result: .failure(.network))
            )
        )

        await viewModel.refresh()

        #expect(viewModel.lastError == .network)
        #expect(viewModel.transactions.isEmpty)
    }
}

/// Deterministic ``RecentTransactionsFetching`` test double.
private struct StubTransactionFetching: RecentTransactionsFetching {
    let result: Result<[Transaction], RecentTransactionsError>

    func fetchRecent(accountId: String?, limit: Int) async throws -> [Transaction] {
        try result.get()
    }
}
