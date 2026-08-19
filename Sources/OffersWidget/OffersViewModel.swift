//  OffersViewModel.swift
//
//  Offers is the one widget the PRD marks soft-fail (§6.5): on error, the
//  widget hides itself entirely rather than showing cached data or an
//  error banner, since it is non-critical to the banking experience.
import Foundation
import Observation
import OffersWidgetInterface

/// The Offers widget's self-contained state and business logic.
@Observable
@MainActor
public final class OffersViewModel {
    public private(set) var offers: [Offer] = []
    public private(set) var isLoading: Bool = false
    public private(set) var didFail: Bool = false

    /// Whether the widget should render anything at all. `false`
    /// collapses the widget to zero height per the soft-fail contract.
    public var shouldRender: Bool {
        isLoading || (!didFail && !offers.isEmpty)
    }

    private let dependencies: OffersDependencies

    /// - Parameter dependencies: The widget's only way to reach the outside world.
    public init(dependencies: OffersDependencies) {
        self.dependencies = dependencies
    }

    /// Loads offers. On failure, no error is surfaced — the widget simply
    /// disappears (PRD §6.5).
    public func refresh() async {
        isLoading = true
        didFail = false
        do {
            offers = try await dependencies.offersFetching.fetchOffers()
        } catch {
            didFail = true
        }
        isLoading = false
    }
}
