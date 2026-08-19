//  TransactionRowView.swift
//
//  Single transaction row with merchant, category, and signed amount that
//  respects the screen-wide reveal/hide toggle (PRD §7 security
//  requirement), shared with Account Summary via ``SharedState/BalanceVisibility``.
import DesignSystem
import Foundation
import RecentTransactionsWidgetInterface
import SwiftUI

/// One transaction's row, styled for debit vs. credit and pending state.
struct TransactionRowView: View {
    let transaction: Transaction
    let isBalanceRevealed: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.merchantName)
                    .font(.subheadline.weight(.medium))
                Text(transaction.isPending ? "\(transaction.category) · Pending" : transaction.category)
                    .font(.caption)
                    .foregroundStyle(BankingPalette.secondaryText)
            }
            Spacer()
            Text(isBalanceRevealed ? formattedAmount : "••••••")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(transaction.amount < 0 ? BankingPalette.primaryText : Color.green)
                .monospacedDigit()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }

    private var formattedAmount: String {
        transaction.amount.formatted(.currency(code: "USD").sign(strategy: .always()))
    }

    private var accessibilityLabel: String {
        let pendingText = transaction.isPending ? ", pending" : ""
        guard isBalanceRevealed else {
            return "\(transaction.merchantName), amount hidden\(pendingText)"
        }
        return "\(transaction.merchantName), \(formattedAmount)\(pendingText)"
    }
}
