//  AccountSummaryError.swift
//
//  Typed error surface for the Account Summary widget. Providers map
//  transport-level errors (URLError, decoding failures, etc.) into this
//  enum at the boundary so the feature layer never switches on them.
import Foundation

/// Errors the Account Summary widget can encounter while loading data.
public enum AccountSummaryError: Error, Equatable, Sendable {
    /// The network request failed (offline, timeout, server error).
    case network
    /// The response could not be decoded into ``Account`` values.
    case decoding
}
