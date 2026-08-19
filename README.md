# ComposableArchitectureDemo (plain SwiftUI)

A single-app SwiftUI demo showing how to build a complex, composite
screen — a banking app's Home tab — as independently-owned modules,
using **no third-party state-management framework**. State is `@Observable`
view models (Swift's own Observation framework); dependencies flow in
through a plain `Dependencies` struct per widget, exactly as described in
the PRD (§6.3) — not through a framework's DI container.

This is the same product slice as the [Composable Architecture branch](../../tree/claude/banking-home-screen-prd-u0hyno),
built to compare: same module graph, same failure-isolation guarantees,
same widget inventory — enforced with first-party Swift/SwiftUI/Foundation
only.

It implements the iOS slice of `docs/PRD-home-screen.md`: account
balances, recent activity, quick actions, and offers, each as its own
feature module with its own state, loading/error/empty handling, and
tests — composed into one screen by a thin `HomeScreen` module that
contains no business logic of its own.

## Module graph

```
BankingDemoApp (executable target — @main, wiring only)
  └── HomeScreen (composition root — layout + dependency wiring, no business logic)
        ├── AccountSummaryWidget ─── AccountSummaryWidgetInterface
        ├── RecentTransactionsWidget ─ RecentTransactionsWidgetInterface
        ├── QuickActionsWidget ───── QuickActionsWidgetInterface
        └── OffersWidget ────────── OffersWidgetInterface

Every <Name>Widget also depends on DesignSystem (shared chrome: card
container, skeleton loader, staleness banner). No widget depends on
another widget — only HomeScreen sees more than one.
```

One `Package.swift` with many targets, same reasoning as the TCA branch:
there's a single app, so each target is a self-contained module (SPM
enforces the dependency direction) without the overhead of a package per
module. The day a second app needs `AccountSummaryWidget`, that target
moves to its own package path unchanged.

## How each widget stays independent

- **Its own state.** Every widget has an `@Observable @MainActor` view
  model (`AccountSummaryViewModel`, `RecentTransactionsViewModel`,
  `QuickActionsViewModel`, `OffersViewModel`) with its own
  loading/error/empty properties. The SwiftUI view owns its view model via
  `@State`, created from the `Dependencies` it was handed — `HomeView`
  never reaches into a widget's internals.
- **Its own `Dependencies` struct — literally, per PRD §6.3.** Each widget
  declares `<Widget>Dependencies` (`AccountSummaryDependencies`,
  `RecentTransactionsDependencies`, `QuickActionsDependencies`,
  `OffersDependencies`), holding the one protocol the widget needs
  (`AccountFetching`, `RecentTransactionsFetching`,
  `QuickActionsEntitlementProviding`, `OffersFetching`) plus, where
  relevant, a `now: () -> Date` clock for deterministic tests. No
  singletons, no service locators — every dependency arrives through an
  initializer. `HomeScreenDependencies` aggregates the four and nothing
  else (PRD §6.3): Home never touches `Account`, `Transaction`, or `Offer`
  directly.
- **Its own failure handling.** A widget catches its own errors inside
  its own view model and never throws into `HomeView`:
  - Account Summary / Recent Transactions: cache-first — a failed
    refresh keeps the last-known data on screen behind a
    `StalenessBanner`.
  - Offers: soft-fail — `OffersViewModel.shouldRender` goes `false` on
    any error and the widget collapses to zero height. It never shows an
    error to the user.
- **No self-navigation.** `QuickActionsWidget` never pushes a screen.
  `QuickActionsDependencies` holds three closures —
  `onTransferTapped` / `onPayBillTapped` / `onDepositTapped` — supplied
  by whoever constructs it, exactly the shape the PRD's own coordinator
  sample (§6.4) specifies. `HomeScreenDependencies.live(...)` takes those
  three closures once at the very top (`AppView`) and threads them all
  the way down; the widget itself only ever calls "the closure for this
  button," never a navigation API.

## Composition without a framework

Rather than a reducer or a store, wiring is a chain of plain factory
methods, each hidden behind its own module boundary:

```
AppView
  → HomeScreenDependencies.live(onTransferTapped:onPayBillTapped:onDepositTapped:)   [HomeScreen]
      → AccountSummaryDependencies.live()        [AccountSummaryWidget]
      → RecentTransactionsDependencies.live()    [RecentTransactionsWidget]
      → QuickActionsDependencies.live(...)       [QuickActionsWidget]
      → OffersDependencies.live()                [OffersWidget]
```

Each `.live()` factory is the one place a widget's module is allowed to
construct its own mock/real provider (`MockAccountProvider`, etc. — all
`internal`, never exposed outside the module) — this is the skill's
Facade + Protocol Provider pattern lifted to package level: `App` only
ever sees the `Dependencies` type and the `.live()` factory, never the
concrete provider.

## Running it

Open `Package.swift` directly in Xcode 16+ (no `.xcodeproj` needed) and
run the `BankingDemoApp` scheme on an iOS 17+ simulator.

```
swift test
```

runs every widget's test suite plus `HomeScreenTests`, independently of
the app target and without any framework's `TestStore` — just plain
`async` calls against a view model constructed with a stub provider.

## Scope narrowed from the PRD

The source PRD (`docs/PRD-home-screen.md`) describes a two-platform,
multi-app monorepo with an app-level `AppCoordinator` /
`AuthCoordinator` / `MainCoordinator` login flow and Android mirrors of
everything here. This repo is deliberately just the iOS Home screen:
one app, no auth flow, no Android module — the point being demonstrated
is widget-level composition (PRD §5–§6.5), not the full app shell.
