// swift-tools-version: 6.0
//  Package.swift
//
//  Single-manifest, multi-target monorepo for the Banking App home screen
//  demo — the plain-SwiftUI variant. No third-party state-management
//  framework: composition is done with `@Observable` view models, plain
//  protocols, and a `Dependencies` struct per widget (PRD §6.3), the same
//  module-boundary story as the Composable Architecture branch, built
//  entirely on first-party Swift/SwiftUI/Observation. One widget still
//  only ever depends on its own <Widget>Interface module, DesignSystem,
//  and Foundation — never on another widget.
import PackageDescription

let package = Package(
    name: "ComposableArchitectureDemo",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "DesignSystem", targets: ["DesignSystem"]),
        .library(name: "SharedState", targets: ["SharedState"]),
        .library(name: "AccountSummaryWidgetInterface", targets: ["AccountSummaryWidgetInterface"]),
        .library(name: "AccountSummaryWidget", targets: ["AccountSummaryWidget"]),
        .library(name: "RecentTransactionsWidgetInterface", targets: ["RecentTransactionsWidgetInterface"]),
        .library(name: "RecentTransactionsWidget", targets: ["RecentTransactionsWidget"]),
        .library(name: "QuickActionsWidgetInterface", targets: ["QuickActionsWidgetInterface"]),
        .library(name: "QuickActionsWidget", targets: ["QuickActionsWidget"]),
        .library(name: "OffersWidgetInterface", targets: ["OffersWidgetInterface"]),
        .library(name: "OffersWidget", targets: ["OffersWidget"]),
        .library(name: "HomeScreen", targets: ["HomeScreen"]),
    ],
    targets: [
        // MARK: Core (zero internal dependencies)
        .target(name: "DesignSystem"),
        .target(name: "SharedState"),

        // MARK: Account Summary widget
        .target(name: "AccountSummaryWidgetInterface"),
        .target(
            name: "AccountSummaryWidget",
            dependencies: ["AccountSummaryWidgetInterface", "DesignSystem", "SharedState"]
        ),
        .testTarget(
            name: "AccountSummaryWidgetTests",
            dependencies: ["AccountSummaryWidget", "AccountSummaryWidgetInterface", "SharedState"]
        ),

        // MARK: Recent Transactions widget
        .target(name: "RecentTransactionsWidgetInterface"),
        .target(
            name: "RecentTransactionsWidget",
            dependencies: ["RecentTransactionsWidgetInterface", "DesignSystem", "SharedState"]
        ),
        .testTarget(
            name: "RecentTransactionsWidgetTests",
            dependencies: ["RecentTransactionsWidget", "RecentTransactionsWidgetInterface", "SharedState"]
        ),

        // MARK: Quick Actions widget
        .target(name: "QuickActionsWidgetInterface"),
        .target(
            name: "QuickActionsWidget",
            dependencies: ["QuickActionsWidgetInterface", "DesignSystem"]
        ),
        .testTarget(name: "QuickActionsWidgetTests", dependencies: ["QuickActionsWidget", "QuickActionsWidgetInterface"]),

        // MARK: Offers widget
        .target(name: "OffersWidgetInterface"),
        .target(
            name: "OffersWidget",
            dependencies: ["OffersWidgetInterface", "DesignSystem"]
        ),
        .testTarget(name: "OffersWidgetTests", dependencies: ["OffersWidget", "OffersWidgetInterface"]),

        // MARK: Home screen (composition root — layout + dependency wiring only)
        .target(
            name: "HomeScreen",
            dependencies: [
                "AccountSummaryWidget",
                "RecentTransactionsWidget",
                "QuickActionsWidget",
                "OffersWidget",
                "DesignSystem",
                "SharedState",
            ]
        ),
        .testTarget(
            name: "HomeScreenTests",
            dependencies: [
                "HomeScreen",
                "AccountSummaryWidget",
                "AccountSummaryWidgetInterface",
                "RecentTransactionsWidget",
                "RecentTransactionsWidgetInterface",
                "QuickActionsWidget",
                "QuickActionsWidgetInterface",
                "OffersWidget",
                "OffersWidgetInterface",
                "SharedState",
            ]
        ),

        // MARK: App (composition root — wiring only, no feature logic)
        .executableTarget(
            name: "BankingDemoApp",
            dependencies: ["HomeScreen", "QuickActionsWidgetInterface"]
        ),
    ]
)
