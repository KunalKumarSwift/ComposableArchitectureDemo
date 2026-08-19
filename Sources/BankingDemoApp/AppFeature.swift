//  AppFeature.swift
//
//  The composition root above HomeScreen. This is where Quick Actions'
//  delegate events finally resolve to something concrete — here, a
//  placeholder alert, since Transfer/Pay Bill/Deposit destinations are
//  out of scope for this demo (PRD §3 non-goals). A real app would push a
//  real flow here instead, without HomeScreen or any widget changing.
import ComposableArchitecture
import Foundation
import HomeScreen

/// Top-level app feature: owns Home and routes its delegate events.
@Reducer
struct AppFeature: Sendable {
    @ObservableState
    struct State: Equatable {
        var home: HomeFeature.State = HomeFeature.State()
        @Presents var alert: AlertState<Action.Alert>?
    }

    enum Action: Sendable {
        case home(HomeFeature.Action)
        case alert(PresentationAction<Alert>)

        enum Alert: Equatable, Sendable {}
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        Reduce { state, action in
            switch action {
            case let .home(.delegate(delegate)):
                state.alert = AppFeature.alertState(for: delegate)
                return .none
            case .home, .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }

    private static func alertState(for delegate: HomeFeature.Action.Delegate) -> AlertState<Action.Alert> {
        let title: String
        switch delegate {
        case .transferTapped: title = "Transfer"
        case .payBillTapped: title = "Pay Bill"
        case .depositTapped: title = "Deposit"
        }
        return AlertState(
            title: { TextState(title) },
            message: { TextState("\(title) is owned by its own feature PRD — Home only exposes the entry point.") }
        )
    }
}
