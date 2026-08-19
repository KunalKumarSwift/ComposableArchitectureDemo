# PRD: Banking App Home Screen

**Status:** Draft
**Owners:** iOS Platform Team / Android Platform Team
**Scope:** Home tab (post-login landing screen)

> This document is the spec this repository implements (iOS slice only —
> see `README.md` for what was built and where it deliberately narrows
> scope from the original two-platform, multi-app PRD below).

---

## 1. Overview

The Home screen is the primary landing surface after login. It surfaces account balances, recent activity, quick actions, and personalized offers. It is built as a **composition of independent widget modules** rather than a monolithic screen — each widget owns its own data, state, and failure handling, and Home is purely a layout/composition root.

## 2. Goals

- Show account balances and recent activity within **P95 < 1.5s** of screen appearance (cache-first, network refresh in background).
- Isolate failure domains: a broken widget (e.g. offers) never blocks or crashes the rest of the screen.
- Allow feature teams to ship/iterate on individual widgets independently, with no cross-widget PRs required.
- Support per-app customization (different apps/brands can compose a different widget set) without duplicating widget code.

## 3. Non-Goals

- Widget-level business logic changes (e.g. new transaction categorization rules) — owned by each widget's team, out of scope for this PRD.
- Deep-link destinations for actions (Transfer, Pay Bill, etc.) — covered by their respective feature PRDs; Home only exposes the entry points.

## 4. User Stories

| ID | Story |
|---|---|
| US-1 | As a customer, I see all my accounts and current balances immediately on opening the app. |
| US-2 | As a customer, I see my most recent transactions without navigating away from Home. |
| US-3 | As a customer, I can start a transfer, bill payment, or deposit directly from Home. |
| US-4 | As a customer, I see relevant offers/promotions without them blocking core banking info. |
| US-5 | As a customer with poor connectivity, I still see my last-known balances (cached) with a clear "as of" indicator. |

## 5. Widget Inventory

| Widget | Priority | Data source | Refresh policy |
|---|---|---|---|
| Account Summary | P0 | Accounts service | Cache-first, refresh on appear + pull-to-refresh |
| Recent Transactions | P0 | Transactions service | Cache-first, refresh on appear (last 5) |
| Quick Actions | P0 | Local config / entitlements | Static, entitlement-gated |
| Offers | P1 | Offers/marketing service | Refresh on appear, soft-fail (hide on error) |

## 6.5 Loading / Error / Empty States (per widget, independently owned)

| State | Account Summary | Recent Transactions | Offers |
|---|---|---|---|
| Loading | Skeleton shimmer, cached data shown if available | Skeleton rows | Skeleton or hidden |
| Error | Cached data + inline "Updated as of X" banner | Cached data + retry affordance | **Hide widget entirely** (soft-fail — non-critical) |
| Empty | N/A (always ≥1 account) | "No recent activity" | Widget collapses (0 height) |

Failure isolation is enforced structurally: each widget catches its own errors internally and never throws into `HomeScreenView`.

## 7. Non-Functional Requirements

- **Performance:** cache-first rendering; network calls fire in parallel, not serially, so one slow widget doesn't delay others.
- **Security:** balances masked by default behind a biometric/PIN reveal toggle stored client-side only (no plaintext balance in logs/analytics).
- **Accessibility:** VoiceOver/TalkBack labels on all balance and transaction rows; Dynamic Type support; minimum 44x44pt tap targets on Quick Actions.
- **Offline:** last-known-good data shown from local cache with visible staleness indicator; no blocking spinners on reopen.
- **Concurrency:** all widget facades `@MainActor`; providers doing I/O are actors; all cross-package models `Sendable` (Swift 6 strict concurrency).

## 8. Analytics

- Widget impression + load-time per widget (P50/P95/P99).
- Widget error rate (by widget, by error type).
- Quick Action tap-through rate per action.
- Offer impression → tap → conversion funnel.

## 9. Rollout Plan

1. Ship `AccountSummaryWidget` + `QuickActionsWidget` behind a feature flag (P0 only), dark-launched.
2. Add `RecentTransactionsWidget`, validate composition performance (P95 load time) with all three live.
3. Add `OffersWidget` last — soft-fail behavior validated in staging before enabling in prod.
4. Gradual rollout: 5% → 25% → 100%, monitored against crash rate and P95 load time regression thresholds.

## 10. Success Metrics

- P95 screen-load time < 1.5s.
- Home-screen crash-free rate ≥ 99.9%.
- Zero cross-widget regressions per widget-team release (measured via independent CI per package/module).
- Quick Action engagement rate (baseline TBD post-launch).

## 11. Open Questions

- Should Offers widget be entitlement-gated (e.g. hidden for business banking customers)?
- Reveal-balance toggle: per-account or global for the whole screen?
- Does Recent Transactions show all accounts combined or per-account (tab/segment)?

The full original PRD (including the multi-app monorepo layout, Android
module layout, and app-level `AppCoordinator`/`AuthCoordinator`/
`MainCoordinator` design) covered a two-platform, multi-app product. This
repository implements the iOS Home screen slice using The Composable
Architecture; see `README.md` for how the scope was deliberately narrowed
to a single app.
