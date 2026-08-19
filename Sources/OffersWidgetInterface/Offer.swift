//  Offer.swift
//
//  Value model shared between OffersWidget and whatever marketing/offers
//  service backs it.
import Foundation

/// A single promotional offer shown on the Home screen.
public struct Offer: Equatable, Identifiable, Sendable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let imageSystemName: String

    /// - Parameters:
    ///   - id: Stable offer identifier.
    ///   - title: Headline copy.
    ///   - subtitle: Supporting copy.
    ///   - imageSystemName: SF Symbol name for the offer's icon.
    public init(id: String, title: String, subtitle: String, imageSystemName: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.imageSystemName = imageSystemName
    }
}
