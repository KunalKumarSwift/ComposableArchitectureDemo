//  QuickActionsView.swift
//
//  Row of entry-point buttons, each at least 44x44pt (PRD §7 accessibility
//  requirement) with VoiceOver labels.
import ComposableArchitecture
import DesignSystem
import QuickActionsWidgetInterface
import SwiftUI

/// SwiftUI presentation of ``QuickActionsFeature``.
public struct QuickActionsView: View {
    private let store: StoreOf<QuickActionsFeature>

    /// - Parameter store: A store scoped to ``QuickActionsFeature``.
    public init(store: StoreOf<QuickActionsFeature>) {
        self.store = store
    }

    public var body: some View {
        WidgetCard(title: "Quick Actions") {
            HStack(spacing: 16) {
                ForEach(store.actions, id: \.self) { kind in
                    Button {
                        store.send(.actionTapped(kind))
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: kind.systemImageName)
                                .font(.title3)
                            Text(kind.title)
                                .font(.caption)
                        }
                        .frame(minWidth: 44, minHeight: 44)
                        .frame(maxWidth: .infinity)
                    }
                    .foregroundStyle(BankingPalette.accent)
                    .accessibilityLabel(kind.title)
                }
            }
        }
        .task { await store.send(.task).finish() }
    }
}
