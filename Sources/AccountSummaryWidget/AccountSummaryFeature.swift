//  AccountSummaryFeature.swift
//
//  Owns all state, loading, and error handling for the Account Summary
//  widget. Cache-first: a failed refresh keeps the last-known accounts on
//  screen behind a staleness banner rather than clearing them (PRD §6.5).
import AccountSummaryWidgetInterface
import ComposableArchitecture
import Foundation

/// The Account Summary widget's self-contained TCA feature.
@Reducer
public struct AccountSummaryFeature: Sendable {
    @ObservableState
    public struct State: Equatable {
        public var accounts: [Account] = []
        public var isLoading: Bool = false
        public var lastError: AccountSummaryError?
        public var lastUpdated: Date?
        public var isBalanceRevealed: Bool = true

        public init() {}
    }

    public enum Action: Sendable {
        case task
        case refreshButtonTapped
        case toggleBalanceVisibility
        case accountsResponse(Result<[Account], AccountSummaryError>)
    }

    private enum CancelID { case load }

    @Dependency(\.accountSummaryClient) private var client: AccountSummaryClient
    @Dependency(\.date) private var date

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .task, .refreshButtonTapped:
                state.isLoading = true
                return .run { send in
                    do {
                        let accounts = try await client.fetchAccounts()
                        await send(.accountsResponse(.success(accounts)))
                    } catch {
                        await send(.accountsResponse(.failure(error as? AccountSummaryError ?? .network)))
                    }
                }
                .cancellable(id: CancelID.load, cancelInFlight: true)

            case .toggleBalanceVisibility:
                state.isBalanceRevealed.toggle()
                return .none

            case let .accountsResponse(.success(accounts)):
                state.isLoading = false
                state.lastError = nil
                state.accounts = accounts
                state.lastUpdated = date.now
                return .none

            case let .accountsResponse(.failure(error)):
                state.isLoading = false
                state.lastError = error
                return .none
            }
        }
    }
}
