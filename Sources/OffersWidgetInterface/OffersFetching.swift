//  OffersFetching.swift
//
//  Contract the OffersWidget depends on to load promotions. Offers is
//  explicitly non-critical (PRD §5): failures here never block Home.
import Foundation

/// Fetches personalized promotional offers.
public protocol OffersFetching: Sendable {
    /// - Returns: Offers to display, in priority order.
    /// - Throws: ``OffersError`` on failure.
    func fetchOffers() async throws -> [Offer]
}
