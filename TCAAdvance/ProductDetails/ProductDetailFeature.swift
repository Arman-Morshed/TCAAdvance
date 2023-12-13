//
//  ProductDetailsFeature.swift
//  TCAAdvance
//
//  Created by Mohammed Rokon Uddin on 12/12/23.
//

import Foundation
import ComposableArchitecture

public struct ProductDetailsFeature: Sendable, FeatureReducer {
    
    @ObservableState
    public struct State: Equatable, Hashable, Identifiable {
        public typealias ID = UUID
        
        public var id: UUID { product.id }
        
        var product: Product
        
        init(product: Product) {
            self.product = product
        }
        
        var productName: String {
            product.name
        }
        
        var productCategory: String {
            product.category.title
        }
        
        var productQuantity: Int {
            product.quantity
        }
        
    }
    
    public enum ViewAction: Equatable {
        case onAppear
    }
    
    public enum InternalAction: Equatable {
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce(core)
    }
    
    public func reduce(into state: inout State, viewAction: ViewAction) -> Effect<Action> {
        switch viewAction {
        case .onAppear:
            return .none
        }
    }
}

