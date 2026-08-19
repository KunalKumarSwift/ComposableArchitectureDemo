//  MockOfferProvider.swift
//
//  Stand-in for a real offers/marketing service.
import Foundation
import OffersWidgetInterface

/// In-memory ``OffersFetching`` conformance returning fixture data after a
/// short simulated network delay.
struct MockOfferProvider: OffersFetching {
    func fetchOffers() async throws -> [Offer] {
        try await Task.sleep(nanoseconds: 400_000_000)
        return [
            Offer(id: "o1", title: "0% APR on new credit cards", subtitle: "For the first 15 months", imageSystemName: "creditcard"),
            Offer(id: "o2", title: "Refer a friend, earn $50", subtitle: "Limited time offer", imageSystemName: "gift"),
        ]
    }
}
