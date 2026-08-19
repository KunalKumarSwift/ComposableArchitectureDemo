//  AppView.swift
//
//  Thin wiring: wraps HomeView in navigation chrome and attaches the
//  alert AppFeature presents for Quick Actions taps.
import ComposableArchitecture
import HomeScreen
import SwiftUI

/// Root SwiftUI view for the app.
struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>

    var body: some View {
        NavigationStack {
            HomeView(store: store.scope(state: \.home, action: \.home))
        }
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}
