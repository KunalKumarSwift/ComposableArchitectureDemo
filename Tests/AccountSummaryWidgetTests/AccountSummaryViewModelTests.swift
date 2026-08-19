//  AccountSummaryViewModelTests.swift
//
//  Demonstrates the widget's independent testability: the view model is
//  exercised with a fake provider, no app, no other widget involved.
import AccountSummaryWidgetInterface
import Foundation
import Testing

@testable import AccountSummaryWidget

@MainActor
struct AccountSummaryViewModelTests {
    @Test
    func refreshSucceedsAndPopulatesAccounts() async {
        let fixedDate = Date(timeIntervalSince1970: 0)
        let account = Account(id: "1", displayName: "Checking", balance: 100, maskedNumber: "•••• 1234", asOf: fixedDate)
        let viewModel = AccountSummaryViewModel(
            dependencies: AccountSummaryDependencies(
                accountFetching: StubAccountFetching(result: .success([account])),
                now: { fixedDate }
            )
        )

        await viewModel.refresh()

        #expect(viewModel.accounts == [account])
        #expect(viewModel.lastError == nil)
        #expect(viewModel.lastUpdated == fixedDate)
        #expect(viewModel.isLoading == false)
    }

    @Test
    func refreshFailureKeepsCachedAccountsAndSetsError() async {
        let account = Account(id: "1", displayName: "Checking", balance: 100, maskedNumber: "•••• 1234", asOf: .now)
        let fetching = SequencedAccountFetching(results: [.success([account]), .failure(.network)])
        let viewModel = AccountSummaryViewModel(
            dependencies: AccountSummaryDependencies(accountFetching: fetching)
        )

        await viewModel.refresh()
        #expect(viewModel.accounts == [account])

        await viewModel.refresh()
        #expect(viewModel.lastError == .network)
        #expect(viewModel.accounts == [account])
    }

    @Test
    func toggleBalanceVisibilityFlipsState() {
        let viewModel = AccountSummaryViewModel(
            dependencies: AccountSummaryDependencies(accountFetching: StubAccountFetching(result: .success([])))
        )

        #expect(viewModel.isBalanceRevealed)
        viewModel.toggleBalanceVisibility()
        #expect(viewModel.isBalanceRevealed == false)
    }
}

/// Deterministic ``AccountFetching`` test double.
private struct StubAccountFetching: AccountFetching {
    let result: Result<[Account], AccountSummaryError>

    func fetchAccounts() async throws -> [Account] {
        try result.get()
    }
}

/// ``AccountFetching`` test double that returns one queued result per call,
/// for asserting behavior across successive refreshes.
private actor SequencedAccountFetching: AccountFetching {
    private var results: [Result<[Account], AccountSummaryError>]

    init(results: [Result<[Account], AccountSummaryError>]) {
        self.results = results
    }

    func fetchAccounts() async throws -> [Account] {
        try results.removeFirst().get()
    }
}
