//  OffersError.swift
//
//  Typed error surface for the Offers widget.
import Foundation

/// Errors the Offers widget can encounter while loading data.
public enum OffersError: Error, Equatable, Sendable {
    /// The network request failed (offline, timeout, server error).
    case network
    /// The response could not be decoded into ``Offer`` values.
    case decoding
}
