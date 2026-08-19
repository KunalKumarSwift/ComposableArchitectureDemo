//  StalenessBanner.swift
//
//  "Updated as of X" indicator shown when a widget is displaying cached
//  data after a failed refresh (PRD §6.5 / US-5 offline behavior).
import Foundation
import SwiftUI

/// An inline banner communicating that displayed data is cached, with an
/// optional retry affordance.
public struct StalenessBanner: View {
    private let asOf: Date
    private let onRetry: (() -> Void)?

    /// - Parameters:
    ///   - asOf: Timestamp of the cached data being shown.
    ///   - onRetry: Retry action; omit to hide the retry button.
    public init(asOf: Date, onRetry: (() -> Void)? = nil) {
        self.asOf = asOf
        self.onRetry = onRetry
    }

    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(BankingPalette.warning)
            Text("Updated as of \(asOf.formatted(date: .omitted, time: .shortened))")
                .font(.caption)
                .foregroundStyle(BankingPalette.secondaryText)
            Spacer()
            if let onRetry {
                Button("Retry", action: onRetry)
                    .font(.caption.weight(.semibold))
            }
        }
    }
}
