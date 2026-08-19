//  OffersView.swift
//
//  Renders nothing (zero height) when there are no offers to show or the
//  load failed — HomeScreen never has to know why, it just lays this view
//  out like any other and it visually collapses on its own.
import ComposableArchitecture
import DesignSystem
import OffersWidgetInterface
import SwiftUI

/// SwiftUI presentation of ``OffersFeature``.
public struct OffersView: View {
    private let store: StoreOf<OffersFeature>

    /// - Parameter store: A store scoped to ``OffersFeature``.
    public init(store: StoreOf<OffersFeature>) {
        self.store = store
    }

    public var body: some View {
        Group {
            if store.shouldRender {
                WidgetCard(title: "Offers for You") {
                    if store.isLoading && store.offers.isEmpty {
                        SkeletonView(height: 60)
                    } else {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(store.offers) { offer in
                                OfferRowView(offer: offer)
                            }
                        }
                    }
                }
            }
        }
        .task { await store.send(.task).finish() }
    }
}

/// One offer's row.
private struct OfferRowView: View {
    let offer: Offer

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: offer.imageSystemName)
                .font(.title3)
                .foregroundStyle(BankingPalette.accent)
            VStack(alignment: .leading, spacing: 2) {
                Text(offer.title)
                    .font(.subheadline.weight(.medium))
                Text(offer.subtitle)
                    .font(.caption)
                    .foregroundStyle(BankingPalette.secondaryText)
            }
        }
        .accessibilityElement(children: .combine)
    }
}
