//  BankingPalette.swift
//
//  Shared color tokens for the demo. A real app would inject these from a
//  brand-specific theme; this demo hardcodes one palette since there is
//  only a single app target.
import SwiftUI

/// Namespaced color tokens shared by every widget so the Home screen
/// reads as one visually consistent surface.
public enum BankingPalette {
    /// Card/widget container background.
    public static let cardBackground: Color = Color(.secondarySystemBackground)

    /// Primary balance / headline text color.
    public static let primaryText: Color = Color(.label)

    /// Secondary / caption text color, used for staleness and metadata.
    public static let secondaryText: Color = Color(.secondaryLabel)

    /// Accent color for interactive elements (buttons, links).
    public static let accent: Color = Color.blue

    /// Color for error/staleness banners.
    public static let warning: Color = Color.orange
}
