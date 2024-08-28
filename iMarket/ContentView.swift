//
//  ContentView.swift
//  iMarket
//
//  Created by Zabdiel Villalobos on 8/27/24.

import SwiftUI

struct ContentView: View {
    // manage the lifecycle of the observable objects :) .
    @StateObject var productViewModel = ProductViewModel()
    @StateObject var cartViewModel = CartViewModel()
    @StateObject var favoritesViewModel = FavoritesViewModel()

    var body: some View {
        // container view that allows switching between different views using tabs.
        TabView {
            // first tab will display the 'ProductsView' and pass in the necessary view models.
            ProductsView(productViewModel: productViewModel, cartViewModel: cartViewModel, favoritesViewModel: favoritesViewModel)
                .tabItem {
                    Image(systemName: "carrot.fill")
                    Text("Products")
                }

            // second tab will display the 'MyItemsView', passing in the favorites and cart view models.
            MyItemsView(favoritesViewModel: favoritesViewModel, cartViewModel: cartViewModel)
                .tabItem {
                    Image(systemName: "heart")
                    Text("My Items")
                }

            // third tab will display the 'CartView', passing in the cart view model.
            CartView(cartViewModel: cartViewModel)
                .tabItem {
                    Image(systemName: "cart")
                    Text("Cart")
                }
                // adds a badge to the tab item displaying the number of items in the cart.
                .badge(cartViewModel.cartItems.count)
        }
    }
}

#Preview {
    ContentView()
}

