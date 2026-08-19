//  QuickActionsView.swift
//
//  Row of entry-point buttons, each at least 44x44pt (PRD §7 accessibility
//  requirement) with VoiceOver labels.
import DesignSystem
import QuickActionsWidgetInterface
import SwiftUI

/// SwiftUI presentation of ``QuickActionsViewModel``.
public struct QuickActionsView: View {
    @State private var viewModel: QuickActionsViewModel

    /// - Parameter dependencies: The widget's only way to reach the outside world.
    public init(dependencies: QuickActionsDependencies) {
        _viewModel = State(initialValue: QuickActionsViewModel(dependencies: dependencies))
    }

    public var body: some View {
        WidgetCard(title: "Quick Actions") {
            HStack(spacing: 16) {
                ForEach(viewModel.actions, id: \.self) { kind in
                    Button {
                        viewModel.actionTapped(kind)
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
        .task { viewModel.loadEntitlements() }
    }
}
