//  SkeletonView.swift
//
//  Shimmering placeholder shown by widgets while their first load is in
//  flight and no cached data exists yet (PRD §6.5 loading state).
import SwiftUI

/// A shimmering rounded-rectangle placeholder for loading states.
public struct SkeletonView: View {
    @State private var isAnimating: Bool = false
    private let height: CGFloat

    /// - Parameter height: Fixed height of the placeholder bar.
    public init(height: CGFloat = 16) {
        self.height = height
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(BankingPalette.secondaryText.opacity(isAnimating ? 0.25 : 0.12))
            .frame(height: height)
            .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: isAnimating)
            .onAppear { isAnimating = true }
            .accessibilityHidden(true)
    }
}
