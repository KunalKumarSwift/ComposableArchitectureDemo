//  AllActionsEntitlementProvider.swift
//
//  Stand-in entitlement provider. A production app would swap this for a
//  provider reading real entitlements (e.g. business banking customers
//  losing access to Deposit), still conforming to the same protocol.
import Foundation
import QuickActionsWidgetInterface

/// ``QuickActionsEntitlementProviding`` conformance that grants every
/// quick action to every customer.
struct AllActionsEntitlementProvider: QuickActionsEntitlementProviding {
    func availableActions() -> [QuickActionKind] {
        QuickActionKind.allCases
    }
}
