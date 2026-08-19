# ComposableArchitectureDemo

A single-app SwiftUI demo showing how to build a complex, composite
screen — a banking app's Home tab — as independently-owned modules
wired together with [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) (TCA).

It implements the iOS slice of `docs/PRD-home-screen.md`: account
balances, recent activity, quick actions, and offers, each as its own
feature module with its own state, loading/error/empty handling, and
tests — composed into one screen by a thin `HomeScreen` module that
contains no business logic of its own.

## Why this shape

The PRD's core requirement is **failure and ownership isolation**: a bug
in the Offers widget must never crash or block Account Summary, and each
widget's team should be able to ship changes without touching the others.
Swift Package Manager module boundaries make that structurally true
instead of just a code-review convention — a widget target physically
cannot import another widget's internals, only its `Interface`.

## Module graph

```
BankingDemoApp (executable target — @main, wiring only)
  └── HomeScreen (composition root — layout + event bubbling, no business logic)
        ├── AccountSummaryWidget ─── AccountSummaryWidgetInterface
        ├── RecentTransactionsWidget ─ RecentTransactionsWidgetInterface
        ├── QuickActionsWidget ───── QuickActionsWidgetInterface
        └── OffersWidget ────────── OffersWidgetInterface

Every <Name>Widget also depends on DesignSystem (shared chrome: card
container, skeleton loader, staleness banner). No widget depends on
another widget — only HomeScreen sees more than one.
```

This is one `Package.swift` with many targets rather than one `Package.swift`
per module, since there's a single app and no second app is reusing any
of these widgets yet. Each target is still a self-contained module with
an enforced dependency direction (SPM refuses dependency cycles) — the
day a second app needs `AccountSummaryWidget`, that target moves to its
own package path unchanged.

## How each widget stays independent

- **Its own state.** Every widget is a `@Reducer` with its own
  `State`/`Action` and its own loading/error/empty cases. `HomeFeature`
  only holds one child state per widget — it never reaches into a
  widget's internals.
- **Its own data dependency.** Each widget declares a TCA
  `@DependencyClient` (`AccountSummaryClient`, `RecentTransactionsClient`,
  `QuickActionsClient`, `OffersClient`) — this is the Composable
  Architecture's version of the PRD's "`Dependencies` struct is the only
  way data enters a widget." Tests override the client per-test; nothing
  is a singleton.
- **Its own failure handling.** A widget catches its own errors inside
  its own reducer and never throws into `HomeScreenView`:
  - Account Summary / Recent Transactions: cache-first — a failed
    refresh keeps the last-known data on screen behind a
    `StalenessBanner`.
  - Offers: soft-fail — `OffersFeature.State.shouldRender` goes `false`
    on any error and the widget collapses to zero height. It never shows
    an error to the user.
- **No self-navigation.** `QuickActionsWidget` never pushes a screen. A
  tap produces `QuickActionsFeature.Action.delegate(...)`, which
  `HomeFeature` re-broadcasts unchanged as its own `delegate` action,
  which `AppFeature` (the composition root above Home) finally resolves —
  here, to a placeholder alert, since Transfer/Pay Bill/Deposit are their
  own PRDs and out of scope. Only the outermost composition root ever
  decides what a tap actually does.

## Running it

Open `Package.swift` directly in Xcode 16+ (no `.xcodeproj` needed — this
follows the same package-as-app-target shape as Apple's sample code) and
run the `BankingDemoApp` scheme on an iOS 17+ simulator.

```
swift test
```

runs every widget's test suite plus `HomeScreenTests`, independently of
the app target — proof that each module is testable on its own.

## Scope narrowed from the PRD

The source PRD (`docs/PRD-home-screen.md`) describes a two-platform,
multi-app monorepo with an app-level `AppCoordinator` /
`AuthCoordinator` / `MainCoordinator` login flow and Android mirrors of
everything here. This repo is deliberately just the iOS Home screen:
one app, no auth flow, no Android module — the point being demonstrated
is widget-level composition (PRD §5–§6.5), not the full app shell.
