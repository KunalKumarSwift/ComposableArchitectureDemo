//  QuickActionKind.swift
//
//  Identifies which quick action was tapped so the composition root can
//  route to the right destination without QuickActionsWidget knowing
//  anything about navigation (PRD §6.4).
import Foundation

/// The set of entry points Quick Actions can expose.
public enum QuickActionKind: String, CaseIterable, Hashable, Sendable {
    case transfer
    case payBill
    case deposit

    /// Display title for the action's button.
    public var title: String {
        switch self {
        case .transfer: return "Transfer"
        case .payBill: return "Pay Bill"
        case .deposit: return "Deposit"
        }
    }

    /// SF Symbol name for the action's icon.
    public var systemImageName: String {
        switch self {
        case .transfer: return "arrow.left.arrow.right"
        case .payBill: return "doc.text"
        case .deposit: return "tray.and.arrow.down"
        }
    }
}
