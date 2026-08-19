//  AccountSummaryClient.swift
//
//  The widget's sole entry point into the outside world, expressed as a
//  TCA dependency. This is the Composable Architecture's answer to the
//  "Dependencies struct" pattern: the live value is swapped for a mock
//  in tests/previews without any singleton or service locator.
import AccountSummaryWidgetInterface
import ComposableArchitecture
import Foundation

/// TCA-dependency-friendly wrapper around ``AccountFetching``.
@DependencyClient
public struct AccountSummaryClient: Sendable {
    /// Fetches the current customer's accounts. See ``AccountFetching``.
    public var fetchAccounts: @Sendable () async throws -> [Account]
}

extension AccountSummaryClient: DependencyKey {
    /// Live value delegates to a real provider. This demo uses an
    /// in-memory mock since there is no backing accounts service.
    public static let liveValue: AccountSummaryClient = AccountSummaryClient(
        fetchAccounts: {
            try await MockAccountProvider().fetchAccounts()
        }
    )
}

extension DependencyValues {
    public var accountSummaryClient: AccountSummaryClient {
        get { self[AccountSummaryClient.self] }
        set { self[AccountSummaryClient.self] = newValue }
    }
}
