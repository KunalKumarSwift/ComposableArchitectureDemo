//  QuickActionsViewModelTests.swift
//
//  Verifies entitlement loading and that taps only ever invoke the
//  composition-root-supplied closure for that action — QuickActionsWidget
//  must never navigate on its own.
import QuickActionsWidgetInterface
import Testing

@testable import QuickActionsWidget

@MainActor
struct QuickActionsViewModelTests {
    @Test
    func loadEntitlementsPopulatesActions() {
        let viewModel = QuickActionsViewModel(
            dependencies: QuickActionsDependencies(
                entitlements: StubEntitlements(actions: [.transfer, .deposit]),
                onTransferTapped: {},
                onPayBillTapped: {},
                onDepositTapped: {}
            )
        )

        viewModel.loadEntitlements()

        #expect(viewModel.actions == [.transfer, .deposit])
    }

    @Test
    func tappingTransferInvokesOnlyTransferClosure() {
        var transferTapped = false
        var payBillTapped = false
        let viewModel = QuickActionsViewModel(
            dependencies: QuickActionsDependencies(
                entitlements: StubEntitlements(actions: [.transfer]),
                onTransferTapped: { transferTapped = true },
                onPayBillTapped: { payBillTapped = true },
                onDepositTapped: {}
            )
        )

        viewModel.actionTapped(.transfer)

        #expect(transferTapped)
        #expect(payBillTapped == false)
    }
}

/// Deterministic ``QuickActionsEntitlementProviding`` test double.
private struct StubEntitlements: QuickActionsEntitlementProviding {
    let actions: [QuickActionKind]

    func availableActions() -> [QuickActionKind] {
        actions
    }
}
