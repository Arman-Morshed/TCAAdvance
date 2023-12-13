//
//  ProductRowView.swift
//  TCAAdvance
//
//  Created by Mohammed Rokon Uddin on 12/13/23.
//

import ComposableArchitecture
import SwiftUI

public struct ProductRowView: View {
    let store: StoreOf<ProductRowFeature>
    
    public init(store: StoreOf<ProductRowFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            
            Text("\(store.productName)")
                .font(.title2)
            
            HStack {
                Text("\(store.productCategory)")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                
                Spacer()
                
                Text("Quantity: \(store.productQuantity)")
                    .font(.callout)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            store.send(.view(.tapped))
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}

#Preview {
    ProductRowView(
        store: .init(initialState: ProductRowFeature.State(product: Product.products.first!),
        reducer: ProductRowFeature.init)
    )
}
