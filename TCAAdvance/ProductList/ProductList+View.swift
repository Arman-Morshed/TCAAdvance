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
                VStack(alignment: .center) {
                    if !viewStore.showLoader {
                        List(viewStore.products, id: \.id) { product in
                            productItem(product)
                        }
                        .padding()
                    } else {
                        ProgressView()
                    }
                    
                    Button {
                        viewStore.send(.view(.addButtonTapped))
                    } label: {
                        Text("Add Product")
                            .frame(width: 120, height: 88)
                    }
                    .disabled(viewStore.showLoader)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .onAppear {
                    viewStore.send(.view(.onAppear))
                }
                .destinations(store: store)
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

private extension StoreOf<ProductList> {
    var destination: PresentationStoreOf<ProductList.Destination> {
        scope(state: \.$destination, action: \.destination)
    }
}

@MainActor
private extension View {
    func destinations(store: StoreOf<ProductList>) -> some View {
        let destinationStore = store.destination
        return addProductItem(with: destinationStore)
    }
    
    @ViewBuilder
    private func addProductItem(with destinationStore: PresentationStoreOf<ProductList.Destination>) -> some View {
        sheet(store:
                destinationStore.scope(
                    state: \.addItemState,
                    action: \.addItemAction)
        ) { store in
            AddProductItem.View(store: store)
        }
    }
}
