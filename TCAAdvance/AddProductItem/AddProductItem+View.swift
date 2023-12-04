//
//  AddProductItem+View.swift
//  TCAAdvance
//
//  Created by Md. Arman Morshed on 2/12/23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

extension AddProductItem {
    @MainActor
    public struct View: SwiftUI.View {
        let store: StoreOf<AddProductItem>
      
        public init(store: StoreOf<AddProductItem>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack {
                    Text("Add Product")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    TextField("Product name", text: viewStore.binding(
                        get: \.name,
                        send: { .view(.setName($0)) }))
                    .textFieldStyle(.roundedBorder)
                    .frame(height: 88)
                    
                    Stepper(
                        "Quantity: \(viewStore.quantity)",
                        value: viewStore.binding(
                            get: \.quantity,
                            send: { .view(.setQuantity($0)) }),
                        in: 0...100
                    )
                    .frame(height: 88)
                    
                    Picker("Product Category", selection: viewStore.binding(
                        get: \.category,
                        send: { .view(.setCategory($0)) })) {
                            ForEach(ProductCategory.allCases) { category in
                                Text(category.title).tag(category)
                            }
                        }
                        .frame(height: 88)
                        .pickerStyle(.segmented)
                    
                    Spacer()
                    
                    Button {
                        viewStore.send(.view(.saveButtonTapped))
                    } label: {
                        Text("Save")
                            .foregroundStyle(.white)
                            .frame(width: 180, height: 44)
                            .background(Color.blue)
                    }

                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
