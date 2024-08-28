//
//  FavoritesViewModel.swift
//  iMarket
//
//  Created by Zabdiel Villalobos on 8/27/24.
//

import Foundation

// manages the list of favorite products.
// observable blah blah = reacts to changes lol
class FavoritesViewModel: ObservableObject {
    
    // holds a list of products that have been marked as favorites.
    // marked with @Published so any changes will automatically update the SwiftUI views that are observing it.
    @Published var favoriteItems: [Product] = []

    // function toggles the favorite status of a product.
    // if product is already a favorite, it removes it. if not it adds it to the favorites.
    func toggleFavorite(product: Product) {
        // check if the product is already in the favoriteItems list.
        if let index = favoriteItems.firstIndex(where: { $0.id == product.id }) {
            // if it is, remove it from the favorites.
            favoriteItems.remove(at: index)
        } else {
            // if it's not, add it to the favorites.
            favoriteItems.append(product)
        }
    }

    // checks if a product is in the favorites list.
    // returns true if the product is a favorite, otherwise false.
    func isFavorite(product: Product) -> Bool {
        // check if the favoriteItems list contains a product with the same ID.
        favoriteItems.contains(where: { $0.id == product.id })
    }
}

