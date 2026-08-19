//  AccountRowView.swift
//
//  Single account row: name, masked number, and balance that respects the
//  screen-level reveal toggle (PRD §7 security requirement).
import AccountSummaryWidgetInterface
import DesignSystem
import Foundation
import SwiftUI

/// One account's balance row, with balance masking support.
struct AccountRowView: View {
    let account: Account
    let isBalanceRevealed: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(account.displayName)
                    .font(.subheadline.weight(.medium))
                Text(account.maskedNumber)
                    .font(.caption)
                    .foregroundStyle(BankingPalette.secondaryText)
            }
            Spacer()
            Text(isBalanceRevealed ? formattedBalance : "••••••")
                .font(.subheadline.weight(.semibold))
                .monospacedDigit()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            isBalanceRevealed
                ? "\(account.displayName), balance \(formattedBalance)"
                : "\(account.displayName), balance hidden"
        )
    }

    private var formattedBalance: String {
        account.balance.formatted(.currency(code: "USD"))
    }
}
