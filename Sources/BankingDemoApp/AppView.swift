//  AppView.swift
//
//  The composition root above HomeScreen. This is where Quick Actions'
//  taps finally resolve to something concrete — here, a placeholder
//  alert, since Transfer/Pay Bill/Deposit destinations are out of scope
//  for this demo (PRD §3 non-goals). A real app would push a real flow
//  from these closures instead, without HomeScreen or any widget
//  changing. App never needs to know any widget's `Dependencies` type —
//  only `HomeScreenDependencies.live(...)`.
import HomeScreen
import QuickActionsWidgetInterface
import SwiftUI

/// Root SwiftUI view for the app.
struct AppView: View {
    @State private var presentedAction: QuickActionKind?

    var body: some View {
        NavigationStack {
            HomeView(
                dependencies: .live(
                    onTransferTapped: { presentedAction = .transfer },
                    onPayBillTapped: { presentedAction = .payBill },
                    onDepositTapped: { presentedAction = .deposit }
                )
            )
        }
        .alert(
            presentedAction?.title ?? "",
            isPresented: Binding(
                get: { presentedAction != nil },
                set: { isPresented in if !isPresented { presentedAction = nil } }
            )
        ) {
            Button("OK") { presentedAction = nil }
        } message: {
            Text("\(presentedAction?.title ?? "") is owned by its own feature PRD — Home only exposes the entry point.")
        }
    }
}
