//  OffersFeature.swift
//
//  Offers is the one widget the PRD marks soft-fail (§6.5): on error, the
//  widget hides itself entirely rather than showing cached data or an
//  error banner, since it is non-critical to the banking experience.
import ComposableArchitecture
import Foundation
import OffersWidgetInterface

/// The Offers widget's self-contained TCA feature.
@Reducer
public struct OffersFeature: Sendable {
    @ObservableState
    public struct State: Equatable {
        public var offers: [Offer] = []
        public var isLoading: Bool = false
        public var didFail: Bool = false

        public init() {}

        /// Whether the widget should render anything at all. `false`
        /// collapses the widget to zero height per the soft-fail contract.
        public var shouldRender: Bool {
            isLoading || (!didFail && !offers.isEmpty)
        }
    }

    public enum Action: Sendable {
        case task
        case offersResponse(Result<[Offer], OffersError>)
    }

    private enum CancelID { case load }

    @Dependency(\.offersClient) private var client: OffersClient

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .task:
                state.isLoading = true
                state.didFail = false
                return .run { send in
                    do {
                        let offers = try await client.fetchOffers()
                        await send(.offersResponse(.success(offers)))
                    } catch {
                        await send(.offersResponse(.failure(error as? OffersError ?? .network)))
                    }
                }
                .cancellable(id: CancelID.load, cancelInFlight: true)

            case let .offersResponse(.success(offers)):
                state.isLoading = false
                state.offers = offers
                return .none

            case .offersResponse(.failure):
                // Soft-fail: no error state is surfaced to the user, the
                // widget simply disappears (PRD §6.5).
                state.isLoading = false
                state.didFail = true
                return .none
            }
        }
    }
}
