// swift-tools-version: 6.0
//  Package.swift
//
//  Single-manifest, multi-target monorepo for the Banking App home screen
//  demo. One app, composed from independently-owned widget feature
//  modules (The Composable Architecture) that only ever depend on their
//  own <Widget>Interface module, DesignSystem, and ComposableArchitecture
//  itself — never on each other. HomeScreen is the composition root that
//  assembles the widgets; BankingDemoApp is the composition root that
//  assembles HomeScreen. This mirrors a real multi-package monorepo, just
//  collapsed into one manifest for demo convenience — each target below
//  is a drop-in candidate for its own SPM package the day a second app
//  needs to reuse it.
import PackageDescription

let package = Package(
    name: "ComposableArchitectureDemo",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "DesignSystem", targets: ["DesignSystem"]),
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
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "1.15.0")),
    ],
    targets: [
        // MARK: Core (zero internal dependencies)
        .target(name: "DesignSystem"),

        // MARK: Account Summary widget
        .target(name: "AccountSummaryWidgetInterface"),
        .target(
            name: "AccountSummaryWidget",
            dependencies: [
                "AccountSummaryWidgetInterface",
                "DesignSystem",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(name: "AccountSummaryWidgetTests", dependencies: ["AccountSummaryWidget"]),

        // MARK: Recent Transactions widget
        .target(name: "RecentTransactionsWidgetInterface"),
        .target(
            name: "RecentTransactionsWidget",
            dependencies: [
                "RecentTransactionsWidgetInterface",
                "DesignSystem",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(name: "RecentTransactionsWidgetTests", dependencies: ["RecentTransactionsWidget"]),

        // MARK: Quick Actions widget
        .target(name: "QuickActionsWidgetInterface"),
        .target(
            name: "QuickActionsWidget",
            dependencies: [
                "QuickActionsWidgetInterface",
                "DesignSystem",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(name: "QuickActionsWidgetTests", dependencies: ["QuickActionsWidget"]),

        // MARK: Offers widget
        .target(name: "OffersWidgetInterface"),
        .target(
            name: "OffersWidget",
            dependencies: [
                "OffersWidgetInterface",
                "DesignSystem",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(name: "OffersWidgetTests", dependencies: ["OffersWidget"]),

        // MARK: Home screen (composition root — layout + event bubbling only)
        .target(
            name: "HomeScreen",
            dependencies: [
                "AccountSummaryWidget",
                "RecentTransactionsWidget",
                "QuickActionsWidget",
                "OffersWidget",
                "DesignSystem",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(name: "HomeScreenTests", dependencies: ["HomeScreen"]),

        // MARK: App (composition root — wiring only, no feature logic)
        .executableTarget(
            name: "BankingDemoApp",
            dependencies: [
                "HomeScreen",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
    ]
)
