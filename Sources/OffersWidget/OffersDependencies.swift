//  OffersDependencies.swift
//
//  The widget's sole entry point into the outside world (PRD §6.3).
import Foundation
import OffersWidgetInterface

/// Everything ``OffersViewModel`` needs from the outside world.
public struct OffersDependencies: Sendable {
    public let offersFetching: any OffersFetching

    /// - Parameter offersFetching: Provider used to load offers.
    public init(offersFetching: any OffersFetching) {
        self.offersFetching = offersFetching
    }
}

extension OffersDependencies {
    /// Default dependencies backed by in-memory fixture data. This demo has
    /// no real offers/marketing service; a production app would swap this
    /// for dependencies backed by a provider calling CoreNetworking.
    public static func live() -> OffersDependencies {
        OffersDependencies(offersFetching: MockOfferProvider())
    }
}
