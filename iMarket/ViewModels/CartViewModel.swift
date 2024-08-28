//
//  CartViewModel.swift
//  iMarket
//
//  Created by Zabdiel Villalobos on 8/27/24.
//

import Foundation

// manages the items in the shopping cart.
// observable = react to changes in the cart.
class CartViewModel: ObservableObject {
    
    // holds list of products that have been added to the cart.
    // marked with @Published so any changes will automatically update the SwiftUI views that are watching it.
    @Published var cartItems: [Product] = []

    // adds a product to the cart, first checks if the product is already in the cart to avoid duplicates.
    func addToCart(product: Product) {
        // if product is not already in the cart, add it. :D
        if !cartItems.contains(where: { $0.id == product.id }) {
            cartItems.append(product)
        }
    }
    
    // removes a product from the cart.
    // looks for the product in the cart by its ID and removes it if found.
    func removeFromCart(product: Product) {
        // find the index of the product in the cart
        if let index = cartItems.firstIndex(where: { $0.id == product.id }) {
            // remove the product at the found index
            cartItems.remove(at: index)
        }
    }

    // checks if a specific product is in the cart.
    // returns true if the product is found, otherwise false.
    func isInCart(product: Product) -> Bool {
        cartItems.contains(where: { $0.id == product.id })
    }
}

