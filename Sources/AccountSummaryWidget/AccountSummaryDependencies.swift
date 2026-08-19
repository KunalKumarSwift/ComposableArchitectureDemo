//  AccountSummaryDependencies.swift
//
//  The widget's sole entry point into the outside world (PRD §6.3): no
//  singletons, no service locators — everything the widget needs to talk
//  to the outside world arrives through this struct's initializer.
import AccountSummaryWidgetInterface
import Foundation

/// Everything ``AccountSummaryViewModel`` needs from the outside world.
public struct AccountSummaryDependencies: Sendable {
    public let accountFetching: any AccountFetching
    public let now: @Sendable () -> Date

    /// - Parameters:
    ///   - accountFetching: Provider used to load accounts. Inject a mock
    ///     in tests/previews, a real provider in the app.
    ///   - now: Clock used to stamp ``AccountSummaryViewModel/lastUpdated``.
    ///     Overridable in tests for deterministic assertions.
    public init(accountFetching: any AccountFetching, now: @escaping @Sendable () -> Date = { .now }) {
        self.accountFetching = accountFetching
        self.now = now
    }
}

extension AccountSummaryDependencies {
    /// Default dependencies backed by in-memory fixture data. This demo has
    /// no real accounts service; a production app would swap this for
    /// dependencies backed by a provider calling CoreNetworking.
    public static func live() -> AccountSummaryDependencies {
        AccountSummaryDependencies(accountFetching: MockAccountProvider())
    }
}
