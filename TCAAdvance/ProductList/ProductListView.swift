//
//  ProductList+View.swift
//  TCAAdvance
//
//  Created by Md. Arman Morshed on 1/12/23.
//

import ComposableArchitecture
import SwiftUI

@MainActor
public struct ProductListView: View {
    @Bindable var store: StoreOf<ProductList>
    
    public init(store: StoreOf<ProductList>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            if !store.showLoader {
                List(store.products, id: \.id) { product in
                    productItem(product)
                }
                .padding()
            } else {
                ProgressView()
            }
            
            Button {
                store.send(.view(.addButtonTapped))
            } label: {
                Text("Add Product")
                    .frame(width: 120, height: 88)
            }
            .disabled(store.showLoader)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .onAppear {
            store.send(.view(.onAppear))
        }
        .destinations(store: store)
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

private extension StoreOf<ProductList> {
    var bindableDestination: Bindable<StoreOf<ProductList>> {
        return Bindable(self)
    }
}

@MainActor
private extension View {
    func destinations(store: StoreOf<ProductList>) -> some View {
        let bindableDestination = store.bindableDestination
        return addProductItem(with: bindableDestination)
    }
    
    @ViewBuilder
    private func addProductItem(with destinationStore: Bindable<StoreOf<ProductList>>) -> some View {
        
        let destinationStore = destinationStore.scope(
            state: \.destination?.addItemState,
            action: \.destination.addItemAction)
        
        sheet(item: destinationStore) { store in
            AddProductItemView(store: store)
        }
    }
}
