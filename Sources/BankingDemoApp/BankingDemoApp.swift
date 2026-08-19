//  BankingDemoApp.swift
//
//  App entry point. The entire composition root. Nothing else in this
//  target may contain feature logic.
import SwiftUI

@main
struct BankingDemoApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}
