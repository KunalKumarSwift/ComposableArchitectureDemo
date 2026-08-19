//  OffersViewModelTests.swift
//
//  Verifies the soft-fail contract: a failed load hides the widget rather
//  than surfacing an error, and never keeps stale offers on screen.
import OffersWidgetInterface
import Testing

@testable import OffersWidget

@MainActor
struct OffersViewModelTests {
    @Test
    func refreshSucceedsAndShowsOffers() async {
        let offer = Offer(id: "1", title: "Title", subtitle: "Subtitle", imageSystemName: "gift")
        let viewModel = OffersViewModel(
            dependencies: OffersDependencies(offersFetching: StubOffersFetching(result: .success([offer])))
        )

        await viewModel.refresh()

        #expect(viewModel.offers == [offer])
        #expect(viewModel.shouldRender)
    }

    @Test
    func refreshFailureHidesWidgetEntirely() async {
        let viewModel = OffersViewModel(
            dependencies: OffersDependencies(offersFetching: StubOffersFetching(result: .failure(.network)))
        )

        await viewModel.refresh()

        #expect(viewModel.didFail)
        #expect(viewModel.offers.isEmpty)
        #expect(viewModel.shouldRender == false)
    }
}

/// Deterministic ``OffersFetching`` test double.
private struct StubOffersFetching: OffersFetching {
    let result: Result<[Offer], OffersError>

    func fetchOffers() async throws -> [Offer] {
        try result.get()
    }
}
