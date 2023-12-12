//
//  AddProductItem+View.swift
//  TCAAdvance
//
//  Created by Md. Arman Morshed on 2/12/23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@MainActor
public struct AddProductItemView: View {
    @Bindable var store: StoreOf<AddProductItem>
    
    public init(store: StoreOf<AddProductItem>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            Text("Add Product")
                .font(.headline)
                .fontWeight(.bold)
            
            TextField("Product name", text: $store.name.sending(\.view.setName))
                .textFieldStyle(.roundedBorder)
                .frame(height: 88)
            
            Stepper(
                "Quantity: \(store.quantity)",
                value: $store.quantity.sending(\.view.setQuantity),
                in: 0...100
            )
            .frame(height: 88)
            
            Picker("Product Category", selection: $store.category.sending(\.view.setCategory)) {
                ForEach(ProductCategory.allCases) { category in
                    Text(category.title).tag(category)
                }
            }
            .frame(height: 88)
            .pickerStyle(.segmented)
            
            Spacer()
            
            Button {
                store.send(.view(.saveButtonTapped))
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
