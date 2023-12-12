//
//  AddProductItem.swift
//  TCAAdvance
//
//  Created by Md. Arman Morshed on 2/12/23.
//

import ComposableArchitecture
import Foundation


// MARK: New way of Binding(@BindingState, BindableAction) not working of composable architecture and can't figure it out why error happening `BindingState<*>' to expected argument type 'Binding<*>`. As new observation beta version will replace the way of binding so does not spend much time on that issue.

public struct AddProductItem: FeatureReducer {
    
    @ObservableState
    public struct State: Equatable, Hashable {
        var name: String = ""
        var quantity: Int = 0
        var category: ProductCategory = .IT
    }
    
    @CasePathable
    public enum ViewAction: Equatable {
        //case binding(BindingAction<State>)
        case saveButtonTapped
        case setName(String)
        case setQuantity(Int)
        case setCategory(ProductCategory)
    }
    
    public enum DelegateAction: Equatable {
        case save(Product)
    }
    
    public var body: some ReducerOf<Self> {
        //BindingReducer(action: \.view)
        
        Reduce(core)
    }
    
    public func reduce(into state: inout State, viewAction: ViewAction) -> Effect<Action> {
        switch viewAction {
//        case .binding:
//            return .none
            
        case .saveButtonTapped:
            let product = Product(name: state.name,
                                  category: state.category,
                                  quantity: state.quantity)
            return .send(.delegate(.save(product)))
            
        case let .setName(name):
            state.name = name
            return .none
            
        case let .setCategory(category):
            state.category = category
            return .none
            
        case let .setQuantity(quantity):
            state.quantity = quantity
            return .none
        }
    }
}
