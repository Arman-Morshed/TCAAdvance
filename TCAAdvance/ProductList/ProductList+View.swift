//
//  ProductList+View.swift
//  TCAAdvance
//
//  Created by Md. Arman Morshed on 1/12/23.
//

import ComposableArchitecture
import SwiftUI

extension ProductList {
    @MainActor
    public struct View: SwiftUI.View {
        let store: StoreOf<ProductList>
        
        public init(store: StoreOf<ProductList>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack(alignment: .leading) {
                    if !viewStore.showLoader {
                        List(viewStore.products, id: \.id) { product in
                            productItem(product)
                        }
                        .padding()
                    } else {
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    viewStore.send(.view(.onAppear))
                }
                .ignoresSafeArea()
            }
        }
        
        @ViewBuilder
        func productItem(_ product: Product) -> some SwiftUI.View {
            VStack(alignment: .leading) {
                Text("\(product.name)")
                    .font(.title)
                   
                Text("\(product.category.title)")
                    .font(.body)
                
                Text("\(product.quantity)")
                    .font(.title2)
            }
        }
    }
}

