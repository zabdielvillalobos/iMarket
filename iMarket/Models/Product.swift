//
//  Product.swift
//  iMarket
//
//  Created by Zabdiel Villalobos on 8/27/24.
//

import Foundation

// response structure expected from the API
struct ProductResponse: Codable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}

// structure for each product
struct Product: Identifiable, Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let thumbnail: String
}

