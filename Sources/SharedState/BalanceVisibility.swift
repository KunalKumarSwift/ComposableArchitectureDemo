//  BalanceVisibility.swift
//
//  The one piece of state more than one widget legitimately needs to
//  share: whether balances render as plain text or masked dots. Lives in
//  a zero-dependency Core module — never inside a widget — so that
//  sharing it never requires one widget to depend on another. Whoever
//  composes the screen (HomeScreen) creates a single instance and hands
//  the same reference to every widget that needs it; `@Observable`
//  publishes each change to every reader, in any widget, automatically.
import Observation

/// Shared, screen-wide toggle for whether balances are shown or masked.
///
/// Explicitly `Sendable`: every stored property is only ever touched
/// through this `@MainActor`-isolated type, so passing the reference
/// itself across a `Dependencies` struct is safe even though its state
/// is mutable.
@Observable
@MainActor
public final class BalanceVisibility: Sendable {
    public var isRevealed: Bool = true

    public init() {}

    /// Flips between shown and masked.
    public func toggle() {
        isRevealed.toggle()
    }
}
