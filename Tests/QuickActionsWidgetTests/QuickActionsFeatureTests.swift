//  QuickActionsFeatureTests.swift
//
//  Verifies entitlement loading and that taps only ever produce delegate
//  events — QuickActionsWidget must never navigate on its own.
import ComposableArchitecture
import Foundation
import QuickActionsWidgetInterface
import Testing

@testable import QuickActionsWidget

@MainActor
struct QuickActionsFeatureTests {
    @Test
    func taskLoadsEntitledActions() async {
        let store = TestStore(initialState: QuickActionsFeature.State()) {
            QuickActionsFeature()
        } withDependencies: {
            $0.quickActionsClient.availableActions = { [.transfer, .deposit] }
        }

        await store.send(.task) {
            $0.actions = [.transfer, .deposit]
        }
    }

    @Test
    func tappingTransferSendsDelegateEvent() async {
        var initialState = QuickActionsFeature.State()
        initialState.actions = [.transfer]
        let store = TestStore(initialState: initialState) {
            QuickActionsFeature()
        }

        await store.send(.actionTapped(.transfer))
        await store.receive(\.delegate.transferTapped)
    }
}
