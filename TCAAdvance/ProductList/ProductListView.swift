//
//  ProductListView.swift
//  TCAAdvance
//
//  Created by Md. Arman Morshed on 1/12/23.
//

import ComposableArchitecture
import SwiftUI

public struct ProductListView: View {
    @Bindable var store: StoreOf<ProductListFeature>
    
    public init(store: StoreOf<ProductListFeature>) {
        self.store = store
    }
    
    public var body: some View {
        List {
            ForEach(store.scope(state: \.rows, action: \.child.product)) { store in
              ProductRowView(store: store)
            }
        }
        .navigationTitle("Products")
        .toolbar {
            Button {
                store.send(.view(.addButtonTapped))
            } label: {
                Image(systemName: "plus")
            }
        }
        .overlay {
            if store.showLoader {
                ProgressView()
            }
        }
        .destinations(store: store)
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
    
    @ViewBuilder
    func productItem(_ product: Product) -> some SwiftUI.View {
        NavigationLink {
            VStack(alignment: .leading) {
                Text("\(product.name)")
                    .font(.title)
                
                Text("\(product.category.title)")
                    .font(.body)
                
                Text("\(product.quantity)")
                    .font(.title2)
            }
        } label: {
            Text("\(product.name)")
        }
        
    }
}

private extension StoreOf<ProductListFeature> {
    var bindableDestination: Bindable<StoreOf<ProductListFeature>> {
        return Bindable(self)
    }
}

@MainActor
private extension View {
    func destinations(store: StoreOf<ProductListFeature>) -> some View {
        let bindableDestination = store.bindableDestination
        return addProductItem(with: bindableDestination)
            .productDetails(with: bindableDestination)
        
    }
    
    @ViewBuilder
    private func addProductItem(with destinationStore: Bindable<StoreOf<ProductListFeature>>) -> some View {
        
        let destinationStore = destinationStore.scope(
            state: \.destination?.addItemState,
            action: \.destination.addItemAction)
        
        sheet(item: destinationStore) { store in
            AddProductView(store: store)
        }
    }
    
    private func productDetails(with destinationStore: Bindable<StoreOf<ProductListFeature>>) -> some View {
        let destinationStore = destinationStore.scope(
            state: \.destination?.productDetails,
            action: \.destination.productDetails)
        
        return navigationDestination(item: destinationStore) { store in
            ProductDetailsView(store: store)
        }
    }
}

//#Preview {
//    ProductListView(
//        store: .init(initialState: ProductListFeature.State(),
//                     reducer: ProductListFeature.init)
//    )
//}
