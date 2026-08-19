//  OffersFeatureTests.swift
//
//  Verifies the soft-fail contract: a failed load hides the widget rather
//  than surfacing an error, and never keeps stale offers on screen.
import ComposableArchitecture
import Foundation
import OffersWidgetInterface
import Testing

@testable import OffersWidget

@MainActor
struct OffersFeatureTests {
    @Test
    func loadSucceedsAndShowsOffers() async {
        let offer = Offer(id: "1", title: "Title", subtitle: "Subtitle", imageSystemName: "gift")
        let store = TestStore(initialState: OffersFeature.State()) {
            OffersFeature()
        } withDependencies: {
            $0.offersClient.fetchOffers = { [offer] }
        }

        await store.send(.task) {
            $0.isLoading = true
        }
        await store.receive(\.offersResponse.success) {
            $0.isLoading = false
            $0.offers = [offer]
        }
        #expect(store.state.shouldRender)
    }

    @Test
    func loadFailureHidesWidgetEntirely() async {
        let store = TestStore(initialState: OffersFeature.State()) {
            OffersFeature()
        } withDependencies: {
            $0.offersClient.fetchOffers = { throw OffersError.network }
        }

        await store.send(.task) {
            $0.isLoading = true
        }
        await store.receive(\.offersResponse.failure) {
            $0.isLoading = false
            $0.didFail = true
        }
        #expect(store.state.shouldRender == false)
        #expect(store.state.offers.isEmpty)
    }
}
