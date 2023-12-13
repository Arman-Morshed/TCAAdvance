//
//  Product.swift
//  TCAAdvance
//
//  Created by Md. Arman Morshed on 2/12/23.
//

import Foundation
import IdentifiedCollections

public enum ProductCategory: String, CaseIterable, Identifiable, Hashable, Equatable {
    case mobile
    case computer
    case electronics
    case accessories
    public var id: ProductCategory { self }
    
    var title: String {
        self.rawValue.capitalized
    }
}

public struct Product: Identifiable, Equatable, Hashable {
    public let id: UUID = UUID()
    public let name: String
    public let category: ProductCategory
    public let quantity: Int
    
    public init(name: String, category: ProductCategory, quantity: Int) {
        self.name = name
        self.category = category
        self.quantity = quantity
    }
}

extension Product {
    static let products: IdentifiedArrayOf<Product> = [
        .init(name: "Mac Mini", category: .computer, quantity: 4),
        .init(name: "Macbook Pro", category: .computer, quantity: 5),
        .init(name: "iPhone 15 Pro Max", category: .mobile, quantity: 5),
        .init(name: "Sony Bravia 64", category: .electronics, quantity: 1),
        .init(name: "Magic Mouse", category: .accessories, quantity: 1)
    ]
}
