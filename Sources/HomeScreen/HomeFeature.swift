//  HomeFeature.swift
//
//  Composition root for the Home tab. Holds no business logic of its own:
//  it only combines each widget's independent reducer and re-broadcasts
//  Quick Actions' delegate events upward, since Home doesn't own
//  navigation either (PRD §6.1, §6.4). This is the one package allowed to
//  depend on multiple feature modules — it plays the same "composition
//  root" role the app target plays over features, just scoped to one
//  screen.
import AccountSummaryWidget
import ComposableArchitecture
import OffersWidget
import QuickActionsWidget
import RecentTransactionsWidget

/// Composes the four Home screen widgets into one screen-level feature.
@Reducer
public struct HomeFeature: Sendable {
    @ObservableState
    public struct State: Equatable {
        public var accountSummary: AccountSummaryFeature.State = AccountSummaryFeature.State()
        public var recentTransactions: RecentTransactionsFeature.State = RecentTransactionsFeature.State()
        public var quickActions: QuickActionsFeature.State = QuickActionsFeature.State()
        public var offers: OffersFeature.State = OffersFeature.State()

        public init() {}
    }

    public enum Action: Sendable {
        case accountSummary(AccountSummaryFeature.Action)
        case recentTransactions(RecentTransactionsFeature.Action)
        case quickActions(QuickActionsFeature.Action)
        case offers(OffersFeature.Action)
        case delegate(Delegate)

        /// Quick Action taps, bubbled up unchanged for the app's
        /// coordinator to route (PRD §6.4).
        public enum Delegate: Equatable, Sendable {
            case transferTapped
            case payBillTapped
            case depositTapped
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.accountSummary, action: \.accountSummary) {
            AccountSummaryFeature()
        }
        Scope(state: \.recentTransactions, action: \.recentTransactions) {
            RecentTransactionsFeature()
        }
        Scope(state: \.quickActions, action: \.quickActions) {
            QuickActionsFeature()
        }
        Scope(state: \.offers, action: \.offers) {
            OffersFeature()
        }
        Reduce { _, action in
            switch action {
            case let .quickActions(.delegate(delegate)):
                return .send(.delegate(HomeFeature.delegateEvent(for: delegate)))
            default:
                return .none
            }
        }
    }

    private static func delegateEvent(for delegate: QuickActionsFeature.Action.Delegate) -> Action.Delegate {
        switch delegate {
        case .transferTapped: return .transferTapped
        case .payBillTapped: return .payBillTapped
        case .depositTapped: return .depositTapped
        }
    }
}
