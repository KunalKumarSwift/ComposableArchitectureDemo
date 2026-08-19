//  BankingDemoApp.swift
//
//  App entry point. The entire composition root: one Store, one Scene.
//  Nothing else in this target may contain feature logic.
import ComposableArchitecture
import SwiftUI

@main
struct BankingDemoApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(initialState: AppFeature.State()) {
                    AppFeature()
                }
            )
        }
    }
}
