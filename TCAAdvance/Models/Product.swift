//
//  Product.swift
//  TCAAdvance
//
//  Created by Md. Arman Morshed on 2/12/23.
//

import Foundation

public enum ProductCategory: String {
    case IT
    case groceries
    
    
    var title: String {
        switch self {
        case .IT:
            return "IT"
        case .groceries:
            return "Groceries"
        }
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
    static let products: [Product] = [
        .init(name: "Mac Mini", category: .IT, quantity: 4),
        .init(name: "Macbook Pro", category: .IT, quantity: 5),
        .init(name: "Rice", category: .groceries, quantity: 5),
        .init(name: "Oil", category: .groceries, quantity: 1)
    ]
}
