//  WidgetCard.swift
//
//  Common card chrome every Home screen widget renders itself inside of.
//  Centralizing this is what makes independently-built widgets look like
//  one coherent screen instead of four different UIs stitched together.
import SwiftUI

/// A titled card container with consistent padding, corner radius, and
/// background used by every Home screen widget.
public struct WidgetCard<Content: View>: View {
    private let title: String
    private let content: Content

    /// - Parameters:
    ///   - title: Heading shown at the top of the card.
    ///   - content: The widget's own content view.
    public init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(BankingPalette.primaryText)
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BankingPalette.cardBackground, in: RoundedRectangle(cornerRadius: 16))
    }
}
