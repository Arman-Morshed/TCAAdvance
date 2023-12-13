//
//  ProductRowFeature.swift
//  TCAAdvance
//
//  Created by Mohammed Rokon Uddin on 12/13/23.
//

import Foundation
import ComposableArchitecture

public struct ProductRowFeature: Sendable, FeatureReducer {
    
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
        case tapped
    }
    
    public enum DelegateAction: Sendable, Equatable {
        case openDetails(id: UUID)
    }
    
    public func reduce(into state: inout State, viewAction: ViewAction) -> Effect<Action> {
        switch viewAction {
        case .onAppear:
            return .none
        case .tapped:
            return .send(.delegate(.openDetails(id: state.id)))
        }
    }
}


