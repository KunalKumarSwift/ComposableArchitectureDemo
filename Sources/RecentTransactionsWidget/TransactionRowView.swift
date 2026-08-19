//  TransactionRowView.swift
//
//  Single transaction row with merchant, category, and signed amount.
import DesignSystem
import Foundation
import RecentTransactionsWidgetInterface
import SwiftUI

/// One transaction's row, styled for debit vs. credit and pending state.
struct TransactionRowView: View {
    let transaction: Transaction

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
            Text(transaction.amount, format: .currency(code: "USD").sign(strategy: .always()))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(transaction.amount < 0 ? BankingPalette.primaryText : Color.green)
                .monospacedDigit()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }

    private var accessibilityLabel: String {
        let amountText = transaction.amount.formatted(.currency(code: "USD"))
        let pendingText = transaction.isPending ? ", pending" : ""
        return "\(transaction.merchantName), \(amountText)\(pendingText)"
    }
}
