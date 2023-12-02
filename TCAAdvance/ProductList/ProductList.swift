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
    
    public struct State: Equatable, Hashable {
        var showLoader = true
        var products: [Product] = []
    }
    
    public enum ViewAction {
        case onAppear
    }
    
    public enum InternalAction {
        case fetchProduct
    }
    
    public func reduce(into state: inout State, viewAction: ViewAction) -> Effect<Action> {
        switch viewAction {
        case .onAppear:
            return .run { send in
               try await continuousClock.sleep(for: .seconds(5))
                await send(.internal(.fetchProduct))
            }
        }
    }
    
    public func reduce(into state: inout State, internalAction: InternalAction) -> Effect<Action> {
        switch internalAction {
        case .fetchProduct:
            state.showLoader = false
            state.products = Product.products
            return .none
        }
    }
}
