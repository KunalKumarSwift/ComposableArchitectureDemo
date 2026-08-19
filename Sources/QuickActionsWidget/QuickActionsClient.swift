//  QuickActionsClient.swift
//
//  TCA dependency wrapping QuickActionsEntitlementProviding. Synchronous
//  and local, unlike the network-backed widget clients.
import ComposableArchitecture
import Foundation
import QuickActionsWidgetInterface

/// TCA-dependency-friendly wrapper around ``QuickActionsEntitlementProviding``.
@DependencyClient
public struct QuickActionsClient: Sendable {
    /// Returns the entitled quick actions. See ``QuickActionsEntitlementProviding``.
    public var availableActions: @Sendable () -> [QuickActionKind] = { QuickActionKind.allCases }
}

extension QuickActionsClient: DependencyKey {
    /// Live value delegates to a real entitlements provider. This demo
    /// grants every action to every customer.
    public static let liveValue: QuickActionsClient = QuickActionsClient(
        availableActions: {
            AllActionsEntitlementProvider().availableActions()
        }
    )
}

extension DependencyValues {
    public var quickActionsClient: QuickActionsClient {
        get { self[QuickActionsClient.self] }
        set { self[QuickActionsClient.self] = newValue }
    }
}
