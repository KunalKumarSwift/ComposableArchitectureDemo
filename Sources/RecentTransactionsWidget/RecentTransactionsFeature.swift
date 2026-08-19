//  RecentTransactionsFeature.swift
//
//  Owns loading, caching, and error handling for the last 5 transactions
//  shown on Home. Cache-first with a visible retry affordance on error
//  (PRD §6.5), independent of every other widget's state.
import ComposableArchitecture
import Foundation
import RecentTransactionsWidgetInterface

/// The Recent Transactions widget's self-contained TCA feature.
@Reducer
public struct RecentTransactionsFeature: Sendable {
    @ObservableState
    public struct State: Equatable {
        public var transactions: [Transaction] = []
        public var isLoading: Bool = false
        public var lastError: RecentTransactionsError?
        public var lastUpdated: Date?

        public init() {}
    }

    public enum Action: Sendable {
        case task
        case retryButtonTapped
        case transactionsResponse(Result<[Transaction], RecentTransactionsError>)
    }

    private enum CancelID { case load }

    /// Matches the "last 5" refresh policy from the widget inventory (PRD §5).
    private static let displayLimit: Int = 5

    @Dependency(\.recentTransactionsClient) private var client: RecentTransactionsClient
    @Dependency(\.date) private var date

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .task, .retryButtonTapped:
                state.isLoading = true
                return .run { send in
                    do {
                        let transactions = try await client.fetchRecent(nil, Self.displayLimit)
                        await send(.transactionsResponse(.success(transactions)))
                    } catch {
                        await send(.transactionsResponse(.failure(error as? RecentTransactionsError ?? .network)))
                    }
                }
                .cancellable(id: CancelID.load, cancelInFlight: true)

            case let .transactionsResponse(.success(transactions)):
                state.isLoading = false
                state.lastError = nil
                state.transactions = transactions
                state.lastUpdated = date.now
                return .none

            case let .transactionsResponse(.failure(error)):
                state.isLoading = false
                state.lastError = error
                return .none
            }
        }
    }
}
