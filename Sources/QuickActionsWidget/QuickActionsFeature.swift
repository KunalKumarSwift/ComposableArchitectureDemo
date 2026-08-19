//  QuickActionsFeature.swift
//
//  Quick Actions never navigates itself (PRD §6.4): a tap only produces a
//  `delegate` action. Whoever composes this widget — HomeScreen, then the
//  app — decides what a tap actually does.
import ComposableArchitecture
import Foundation
import QuickActionsWidgetInterface

/// The Quick Actions widget's self-contained TCA feature.
@Reducer
public struct QuickActionsFeature: Sendable {
    @ObservableState
    public struct State: Equatable {
        public var actions: [QuickActionKind] = []

        public init() {}
    }

    public enum Action: Sendable {
        case task
        case actionTapped(QuickActionKind)
        case delegate(Delegate)

        /// Events the composition root reacts to; never handled internally.
        public enum Delegate: Equatable, Sendable {
            case transferTapped
            case payBillTapped
            case depositTapped
        }
    }

    @Dependency(\.quickActionsClient) private var client: QuickActionsClient

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .task:
                state.actions = client.availableActions()
                return .none

            case let .actionTapped(kind):
                return .send(.delegate(delegateEvent(for: kind)))

            case .delegate:
                return .none
            }
        }
    }

    private func delegateEvent(for kind: QuickActionKind) -> Action.Delegate {
        switch kind {
        case .transfer: return .transferTapped
        case .payBill: return .payBillTapped
        case .deposit: return .depositTapped
        }
    }
}
