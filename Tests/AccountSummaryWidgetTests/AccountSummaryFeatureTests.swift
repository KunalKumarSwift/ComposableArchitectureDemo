//  AccountSummaryFeatureTests.swift
//
//  Demonstrates the widget's independent testability: the feature is
//  exercised with a fake client, no app, no other widget involved.
import AccountSummaryWidgetInterface
import ComposableArchitecture
import Foundation
import Testing

@testable import AccountSummaryWidget

@MainActor
struct AccountSummaryFeatureTests {
    @Test
    func loadSucceedsAndPopulatesAccounts() async {
        let fixedDate = Date(timeIntervalSince1970: 0)
        let account = Account(id: "1", displayName: "Checking", balance: 100, maskedNumber: "•••• 1234", asOf: fixedDate)
        let store = TestStore(initialState: AccountSummaryFeature.State()) {
            AccountSummaryFeature()
        } withDependencies: {
            $0.accountSummaryClient.fetchAccounts = { [account] }
            $0.date = .constant(fixedDate)
        }

        await store.send(.task) {
            $0.isLoading = true
        }
        await store.receive(\.accountsResponse.success) {
            $0.isLoading = false
            $0.accounts = [account]
            $0.lastUpdated = fixedDate
        }
    }

    @Test
    func loadFailureKeepsCachedAccountsAndSetsError() async {
        let account = Account(id: "1", displayName: "Checking", balance: 100, maskedNumber: "•••• 1234", asOf: .now)
        var initialState = AccountSummaryFeature.State()
        initialState.accounts = [account]
        let store = TestStore(initialState: initialState) {
            AccountSummaryFeature()
        } withDependencies: {
            $0.accountSummaryClient.fetchAccounts = { throw AccountSummaryError.network }
        }

        await store.send(.refreshButtonTapped) {
            $0.isLoading = true
        }
        await store.receive(\.accountsResponse.failure) {
            $0.isLoading = false
            $0.lastError = .network
        }
        #expect(store.state.accounts == [account])
    }

    @Test
    func toggleBalanceVisibilityFlipsState() async {
        let store = TestStore(initialState: AccountSummaryFeature.State()) {
            AccountSummaryFeature()
        }

        await store.send(.toggleBalanceVisibility) {
            $0.isBalanceRevealed = false
        }
    }
}
