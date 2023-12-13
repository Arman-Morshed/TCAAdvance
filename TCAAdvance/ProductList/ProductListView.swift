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
            ForEachStore(
                store.scope(
                    state: \.rows,
                    action: { .child(.product($0, $1)) }
                ),
                content: {
                    ProductRowView(store: $0)
                }
            )
            
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

private extension StoreOf<ProductListFeature> {
    var destination: PresentationStoreOf<ProductListFeature.Destination> {
        func scopeState(state: State) -> PresentationState<ProductListFeature.Destination.State> {
            state.$destination
        }
        return scope(state: scopeState, action: Action.destination)
    }
}


@MainActor
private extension View {
    func destinations(store: StoreOf<ProductListFeature>) -> some View {
        let destination = store.destination
        let bindableDestination = store.bindableDestination
        return addProductItem(with: bindableDestination)
            .productDetails(with: destination)
        
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
    
    private func productDetails(with destinationStore: PresentationStoreOf<ProductListFeature.Destination>) -> some View {
        navigationDestination(
            store: destinationStore,
            state: /ProductListFeature.Destination.State.productDetails,
            action: ProductListFeature.Destination.Action.productDetails,
            destination: { ProductDetailsView(store: $0) }
        )
    }
}

//#Preview {
//    ProductListView(
//        store: .init(initialState: ProductListFeature.State(),
//                     reducer: ProductListFeature.init)
//    )
//}
