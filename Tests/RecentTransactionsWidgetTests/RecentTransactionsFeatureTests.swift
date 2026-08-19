//  RecentTransactionsFeatureTests.swift
//
//  Independent test coverage for the Recent Transactions widget.
import ComposableArchitecture
import Foundation
import RecentTransactionsWidgetInterface
import Testing

@testable import RecentTransactionsWidget

@MainActor
struct RecentTransactionsFeatureTests {
    @Test
    func loadSucceedsAndPopulatesTransactions() async {
        let fixedDate = Date(timeIntervalSince1970: 0)
        let transaction = Transaction(id: "1", merchantName: "Coffee", amount: -5, date: fixedDate, category: "Dining", isPending: false)
        let store = TestStore(initialState: RecentTransactionsFeature.State()) {
            RecentTransactionsFeature()
        } withDependencies: {
            $0.recentTransactionsClient.fetchRecent = { _, _ in [transaction] }
            $0.date = .constant(fixedDate)
        }

        await store.send(.task) {
            $0.isLoading = true
        }
        await store.receive(\.transactionsResponse.success) {
            $0.isLoading = false
            $0.transactions = [transaction]
            $0.lastUpdated = fixedDate
        }
    }

    @Test
    func loadFailureSetsErrorWithoutCachedData() async {
        let store = TestStore(initialState: RecentTransactionsFeature.State()) {
            RecentTransactionsFeature()
        } withDependencies: {
            $0.recentTransactionsClient.fetchRecent = { _, _ in throw RecentTransactionsError.network }
        }

        await store.send(.task) {
            $0.isLoading = true
        }
        await store.receive(\.transactionsResponse.failure) {
            $0.isLoading = false
            $0.lastError = .network
        }
        #expect(store.state.transactions.isEmpty)
    }
}
