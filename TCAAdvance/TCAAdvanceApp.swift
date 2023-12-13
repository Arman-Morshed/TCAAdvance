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
            NavigationStack {
                AppView(store:
                        .init(
                            initialState: ProductListFeature.State(
                                rows: .init(
                                    uniqueElements: []
                                )
                            ),
                            reducer: {
                                ProductListFeature()
                                    ._printChanges()
                            }
                        )
                )
            }
        }
    }
}
