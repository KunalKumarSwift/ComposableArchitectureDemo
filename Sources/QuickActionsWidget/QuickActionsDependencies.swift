//  QuickActionsDependencies.swift
//
//  Quick Actions never navigates itself (PRD §6.4): it only exposes
//  closures the composition root supplies, so different apps can route
//  the same tap differently without touching this widget's code.
import Foundation
import QuickActionsWidgetInterface

/// Everything ``QuickActionsViewModel`` needs from the outside world.
public struct QuickActionsDependencies: Sendable {
    public let entitlements: any QuickActionsEntitlementProviding
    public let onTransferTapped: @Sendable () -> Void
    public let onPayBillTapped: @Sendable () -> Void
    public let onDepositTapped: @Sendable () -> Void

    /// - Parameters:
    ///   - entitlements: Determines which actions the customer may see.
    ///   - onTransferTapped: Invoked when the Transfer button is tapped.
    ///   - onPayBillTapped: Invoked when the Pay Bill button is tapped.
    ///   - onDepositTapped: Invoked when the Deposit button is tapped.
    public init(
        entitlements: any QuickActionsEntitlementProviding,
        onTransferTapped: @escaping @Sendable () -> Void,
        onPayBillTapped: @escaping @Sendable () -> Void,
        onDepositTapped: @escaping @Sendable () -> Void
    ) {
        self.entitlements = entitlements
        self.onTransferTapped = onTransferTapped
        self.onPayBillTapped = onPayBillTapped
        self.onDepositTapped = onDepositTapped
    }
}

extension QuickActionsDependencies {
    /// Default entitlements (every action, for every customer) with
    /// app-supplied navigation closures. This demo has no real
    /// entitlements service; a production app would swap the entitlements
    /// provider for one backed by CoreNetworking.
    public static func live(
        onTransferTapped: @escaping @Sendable () -> Void,
        onPayBillTapped: @escaping @Sendable () -> Void,
        onDepositTapped: @escaping @Sendable () -> Void
    ) -> QuickActionsDependencies {
        QuickActionsDependencies(
            entitlements: AllActionsEntitlementProvider(),
            onTransferTapped: onTransferTapped,
            onPayBillTapped: onPayBillTapped,
            onDepositTapped: onDepositTapped
        )
    }
}
