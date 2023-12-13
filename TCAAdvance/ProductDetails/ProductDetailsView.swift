//
//  ProductDetailsView.swift
//  TCAAdvance
//
//  Created by Mohammed Rokon Uddin on 12/12/23.
//

import ComposableArchitecture
import SwiftUI

public struct ProductDetailsView: View {
    let store: StoreOf<ProductDetailsFeature>
    
    public init(store: StoreOf<ProductDetailsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("\(store.productName)")
                .font(.title)
            
            Text("\(store.productCategory)")
                .font(.body)
            
            Text("\(store.productQuantity)")
                .font(.title2)
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}
