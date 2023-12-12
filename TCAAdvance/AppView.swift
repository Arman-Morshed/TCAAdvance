//
//  AppView.swift
//  TCAAdvance
//
//  Created by Md. Arman Morshed on 28/11/23.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: StoreOf<ProductList>
    
    var body: some View {
        ProductListView(store: store)
    }
}

#Preview {
    AppView(store:
            .init(
                initialState: ProductList.State(),
                reducer: { ProductList()
                }
            )
    )
}
