//  OffersView.swift
//
//  Renders nothing (zero height) when there are no offers to show or the
//  load failed — HomeScreen never has to know why, it just lays this view
//  out like any other and it visually collapses on its own.
import DesignSystem
import OffersWidgetInterface
import SwiftUI

/// SwiftUI presentation of ``OffersViewModel``.
public struct OffersView: View {
    @State private var viewModel: OffersViewModel

    /// - Parameter dependencies: The widget's only way to reach the outside world.
    public init(dependencies: OffersDependencies) {
        _viewModel = State(initialValue: OffersViewModel(dependencies: dependencies))
    }

    public var body: some View {
        Group {
            if viewModel.shouldRender {
                WidgetCard(title: "Offers for You") {
                    if viewModel.isLoading && viewModel.offers.isEmpty {
                        SkeletonView(height: 60)
                    } else {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(viewModel.offers) { offer in
                                OfferRowView(offer: offer)
                            }
                        }
                    }
                }
            }
        }
        .task { await viewModel.refresh() }
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
