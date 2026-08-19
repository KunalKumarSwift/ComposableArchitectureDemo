//  AccountSummaryDependencies.swift
//
//  The widget's sole entry point into the outside world (PRD §6.3): no
//  singletons, no service locators — everything the widget needs to talk
//  to the outside world arrives through this struct's initializer.
import AccountSummaryWidgetInterface
import Foundation
import SharedState

/// Everything ``AccountSummaryViewModel`` needs from the outside world.
public struct AccountSummaryDependencies: Sendable {
    public let accountFetching: any AccountFetching
    public let now: @Sendable () -> Date
    public let balanceVisibility: BalanceVisibility

    /// - Parameters:
    ///   - accountFetching: Provider used to load accounts. Inject a mock
    ///     in tests/previews, a real provider in the app.
    ///   - now: Clock used to stamp ``AccountSummaryViewModel/lastUpdated``.
    ///     Overridable in tests for deterministic assertions.
    ///   - balanceVisibility: Shared reveal/hide toggle. Pass the same
    ///     instance given to ``RecentTransactionsDependencies`` so both
    ///     widgets mask balances together; defaults to a private instance
    ///     for widgets tested in isolation.
    public init(
        accountFetching: any AccountFetching,
        now: @escaping @Sendable () -> Date = { .now },
        balanceVisibility: BalanceVisibility = BalanceVisibility()
    ) {
        self.accountFetching = accountFetching
        self.now = now
        self.balanceVisibility = balanceVisibility
    }
}

extension AccountSummaryDependencies {
    /// Default dependencies backed by in-memory fixture data. This demo has
    /// no real accounts service; a production app would swap this for
    /// dependencies backed by a provider calling CoreNetworking.
    /// - Parameter balanceVisibility: Shared reveal/hide toggle supplied by
    ///   the composition root so it can be handed to other widgets too.
    public static func live(balanceVisibility: BalanceVisibility) -> AccountSummaryDependencies {
        AccountSummaryDependencies(accountFetching: MockAccountProvider(), balanceVisibility: balanceVisibility)
    }
}
