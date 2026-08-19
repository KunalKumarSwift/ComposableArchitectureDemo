//  OffersClient.swift
//
//  TCA dependency wrapping OffersFetching, mirroring the other widgets'
//  client pattern.
import ComposableArchitecture
import Foundation
import OffersWidgetInterface

/// TCA-dependency-friendly wrapper around ``OffersFetching``.
@DependencyClient
public struct OffersClient: Sendable {
    /// Fetches promotional offers. See ``OffersFetching``.
    public var fetchOffers: @Sendable () async throws -> [Offer]
}

extension OffersClient: DependencyKey {
    /// Live value delegates to a real provider. This demo uses an
    /// in-memory mock since there is no backing offers service.
    public static let liveValue: OffersClient = OffersClient(
        fetchOffers: {
            try await MockOfferProvider().fetchOffers()
        }
    )
}

extension DependencyValues {
    public var offersClient: OffersClient {
        get { self[OffersClient.self] }
        set { self[OffersClient.self] = newValue }
    }
}
