//  QuickActionsViewModel.swift
//
//  Loads the entitled actions and forwards taps to whichever closure the
//  composition root supplied. This view model never knows what a tap
//  actually does downstream.
import Foundation
import Observation
import QuickActionsWidgetInterface

/// The Quick Actions widget's self-contained state and business logic.
@Observable
@MainActor
public final class QuickActionsViewModel {
    public private(set) var actions: [QuickActionKind] = []

    private let dependencies: QuickActionsDependencies

    /// - Parameter dependencies: The widget's only way to reach the outside world.
    public init(dependencies: QuickActionsDependencies) {
        self.dependencies = dependencies
    }

    /// Loads the actions the current customer is entitled to see.
    public func loadEntitlements() {
        actions = dependencies.entitlements.availableActions()
    }

    /// Forwards a tap to the composition-root-supplied closure for `kind`.
    /// - Parameter kind: Which quick action was tapped.
    public func actionTapped(_ kind: QuickActionKind) {
        switch kind {
        case .transfer: dependencies.onTransferTapped()
        case .payBill: dependencies.onPayBillTapped()
        case .deposit: dependencies.onDepositTapped()
        }
    }
}
