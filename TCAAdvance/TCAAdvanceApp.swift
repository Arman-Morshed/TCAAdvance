//
//  TCAAdvanceApp.swift
//  TCAAdvance
//
//  Created by Md. Arman Morshed on 28/11/23.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCAAdvanceApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(store:
                    .init(
                        initialState: ProductList.State(),
                        reducer: { 
                            ProductList()
                                ._printChanges()
                        }
                    )
            )
        }
    }
}
