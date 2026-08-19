//  HomeFeatureTests.swift
//
//  Verifies HomeFeature's only piece of real logic: bubbling a Quick
//  Actions delegate event up unchanged. Everything else is pure
//  composition, already covered by each widget's own tests.
import ComposableArchitecture
import Testing

@testable import HomeScreen
@testable import QuickActionsWidget

@MainActor
struct HomeFeatureTests {
    @Test
    func quickActionsDelegateBubblesUpAsHomeDelegate() async {
        let store = TestStore(initialState: HomeFeature.State()) {
            HomeFeature()
        }

        await store.send(.quickActions(.actionTapped(.transfer)))
        await store.receive(\.quickActions.delegate.transferTapped)
        await store.receive(\.delegate.transferTapped)
    }
}
