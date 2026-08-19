//  QuickActionsEntitlementProviding.swift
//
//  Quick Actions is local config, entitlement-gated rather than fetched
//  from a service (PRD §5). This protocol is the seam for that gating.
import Foundation

/// Determines which quick actions the current customer is entitled to see.
public protocol QuickActionsEntitlementProviding: Sendable {
    /// - Returns: The quick actions available to the current customer, in
    ///   display order.
    func availableActions() -> [QuickActionKind]
}
