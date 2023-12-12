//
//  ProductList.swift
//  TCAAdvance
//
//  Created by Md. Arman Morshed on 1/12/23.
//

import Foundation
import ComposableArchitecture

public struct ProductList: Sendable, FeatureReducer {
    @Dependency(\.continuousClock) var continuousClock
    
    @ObservableState
    public struct State: Equatable, Hashable {
        var showLoader = true
        var products: IdentifiedArrayOf<Product> = []
        
        @Presents var destination: Destination.State?
    }
    
    public enum ViewAction: Equatable {
        case onAppear
        case addButtonTapped
    }
    
    public enum InternalAction: Equatable {
        case fetchProduct
        case addProduct(Product)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce(core)
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
            state.products = Product.products
            return .none
            
        case let .addProduct(product):
            state.products.append(product)
            return .none
        }
    }
    
    public struct Destination: DestinationReducer {
        
        @dynamicMemberLookup
        @CasePathable
        public enum State: Hashable {
            case addItemState(AddProductItem.State)
        }
        
        @CasePathable
        public enum Action: Equatable {
            case addItemAction(AddProductItem.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.addItemState, action: \.addItemAction) {
                AddProductItem()
            }
        }
    }
    
    private func dismissAddProductScreen(then internalAction: InternalAction, _ state: inout State) -> Effect<Action> {
        state.destination = nil
        return .send(.internal(internalAction))
    }
}
