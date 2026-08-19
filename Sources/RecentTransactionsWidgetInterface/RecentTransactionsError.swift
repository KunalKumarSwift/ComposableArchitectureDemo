//  RecentTransactionsError.swift
//
//  Typed error surface for the Recent Transactions widget.
import Foundation

/// Errors the Recent Transactions widget can encounter while loading data.
public enum RecentTransactionsError: Error, Equatable, Sendable {
    /// The network request failed (offline, timeout, server error).
    case network
    /// The response could not be decoded into ``Transaction`` values.
    case decoding
}
