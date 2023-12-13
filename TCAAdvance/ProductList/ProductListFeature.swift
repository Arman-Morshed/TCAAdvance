//
//  ProductList.swift
//  TCAAdvance
//
//  Created by Md. Arman Morshed on 1/12/23.
//

import Foundation
import ComposableArchitecture

public struct ProductListFeature: Sendable, FeatureReducer {
    @Dependency(\.continuousClock) var continuousClock
    
    @ObservableState
    public struct State: Equatable, Hashable {
        var showLoader = true
        public var rows: IdentifiedArrayOf<ProductRowFeature.State> = []
        @Presents var destination: Destination.State?
        
        init(rows: IdentifiedArrayOf<ProductRowFeature.State>) {
            self.rows = rows
        }
    }
    
    public enum ViewAction: Equatable {
        case onAppear
        case addButtonTapped
    }
    
    public enum InternalAction: Equatable {
        case fetchProduct
        case addProduct(Product)
    }
    
    public enum ChildAction: Sendable, Equatable {
        case product(ProductRowFeature.State.ID, ProductRowFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce(core)
            .forEach(\.rows, action: /Action.child .. ChildAction.product) {
                ProductRowFeature()
            }
            .ifLet(\.$destination, action: \.destination) {
                Destination()
            }
    }
    
    public func reduce(into state: inout State, viewAction: ViewAction) -> Effect<Action> {
        switch viewAction {
        case .onAppear:
            return .run { send in
               try await continuousClock.sleep(for: .seconds(1))
                await send(.internal(.fetchProduct))
            }
            
        case .addButtonTapped:
            state.destination = .addItemState(.init())
            return .none
        }
    }
    
    public func reduce(into state: inout State, presentedAction: Destination.Action) -> Effect<Action> {
        switch presentedAction {
        case let .addItemAction(.delegate(.save(product))):
            return dismissAddProductScreen(then: .addProduct(product), &state)
        
        default:
            return .none
        }
    }
    
    public func reduce(into state: inout State, internalAction: InternalAction) -> Effect<Action> {
        switch internalAction {
        case .fetchProduct:
            state.showLoader = false
            state.rows = .init(uniqueElements: Product.products.map { ProductRowFeature.State(product: $0) })
            return .none
            
        case let .addProduct(product):
            state.rows.append(ProductRowFeature.State(product: product))
            return .none
        }
    }
    
    public func reduce(into state: inout State, childAction: ChildAction) -> Effect<Action> {
        switch childAction {
        case let .product(id, .delegate(delegateAction)):
            guard let productRow = state.rows[id: id] else { return .none }
            let product = productRow.product
            switch delegateAction {
            case .openDetails:
                state.destination = .productDetails(.init(product: product))
                return .none
            }

        default:
            return .none
        }
    }
    
    public struct Destination: DestinationReducer {
        
        @dynamicMemberLookup
        @CasePathable
        public enum State: Hashable {
            case addItemState(AddProductFeature.State)
            case productDetails(ProductDetailsFeature.State)
        }
        
        @CasePathable
        public enum Action: Equatable {
            case addItemAction(AddProductFeature.Action)
            case productDetails(ProductDetailsFeature.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.addItemState, action: \.addItemAction) {
                AddProductFeature()
            }
            
            Scope(state: \.productDetails, action: \.productDetails) {
                ProductDetailsFeature()
            }
        }
    }
    
    private func dismissAddProductScreen(then internalAction: InternalAction, _ state: inout State) -> Effect<Action> {
        state.destination = nil
        return .send(.internal(internalAction))
    }
}
