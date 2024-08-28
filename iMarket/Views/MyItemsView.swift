//
//  MyItemsView.swift
//  iMarket
//
//  Created by Zabdiel Villalobos on 8/27/24.
//

import SwiftUI

struct MyItemsView: View {
    // ObservedObject property wrapper to monitor changes in favoritesViewModel
    // Updates the view when the data in the view model changes and also cart data changes :o
    @ObservedObject var favoritesViewModel: FavoritesViewModel
    @ObservedObject var cartViewModel: CartViewModel

    var body: some View {
        NavigationView {
            // Grouping UI elements conditionally based on favorite items' availability
            Group {
                // Check if the favorite items list is empty
                if favoritesViewModel.favoriteItems.isEmpty {
                    // Display a message when no items are in favorites
                    VStack {
                        Text("No items in your favorites yet.")
                            .foregroundColor(.gray) // Set the text color to gray
                            .padding()
                    }
                } else {
                    // Display a list of favorite items
                    List(favoritesViewModel.favoriteItems) { product in
                        HStack {
                            // Asynchronously load an image from a URL
                            AsyncImage(url: URL(string: product.thumbnail)) { phase in
                                // Handle different loading states of the image
                                switch phase {
                                case .empty:
                                    // Display a progress view while the image is loading
                                    ProgressView()
                                        .frame(width: 128, height: 128)
                                        .cornerRadius(8) // Rounded corners
                                case .success(let image):
                                    // Display the loaded image, with resizing and rounded corners
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 128, height: 128)
                                        .cornerRadius(8)
                                case .failure:
                                    // Display a red color block if the image fails to load
                                    Color.red
                                        .frame(width: 128, height: 128)
                                        .cornerRadius(8)
                                @unknown default:
                                    // Fallback view for any unknown state
                                    EmptyView()
                                }
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                // Display the product title
                                Text(product.title)
                                    .font(.system(size: 17))
                                    .lineSpacing(22)
                                    .kerning(-0.41) // Adjust character spacing
                                    .lineLimit(1) // Limit to one line
                                    .padding(.bottom, 2)
                                    .foregroundColor(Color(red: 235/255, green: 235/255, blue: 245/255))

                                // Display the product price
                                Text("$\(product.price, specifier: "%.2f")")
                                    .font(.system(size: 20, weight: .bold))
                                    .lineSpacing(24)

                                // Display the product category
                                Text(product.category.capitalized)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                    .background(Color(red: 58/255, green: 58/255, blue: 60/255))
                                    .cornerRadius(4)
                                    .padding(.bottom, 8) // Bottom padding

                                // HStack for the "Add to Cart" and "Favorite"
                                HStack(spacing: 10) {
                                    // "Add to Cart" button
                                    Button(action: {
                                        cartViewModel.addToCart(product: product) // Action to add product to cart
                                    }) {
                                        Text("Add to Cart")
                                            .font(.system(size: 17))
                                            .frame(maxWidth: .infinity, maxHeight: 36)
                                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)) // Padding inside the button
                                            .background(Color.blue)
                                            .cornerRadius(100)
                                            .foregroundColor(.white)
                                    }

                                    // "Favorite" button with heart icon
                                    Button(action: {
                                        favoritesViewModel.toggleFavorite(product: product) // Toggle favorite status
                                    }) {
                                        // Check if the product is favorite and display the appropriate heart icon
                                        Image(systemName: favoritesViewModel.isFavorite(product: product) ? "heart.fill" : "heart")
                                            .font(.system(size: 17)) // Set font size for icon
                                            .frame(width: 36, height: 36) // Set icon button size
                                            .background(Color(red: 58/255, green: 58/255, blue: 60/255)) // Background color for button
                                            .cornerRadius(100) // Rounded corners
                                            .foregroundColor(.white) // White icon color
                                    }
                                }
                            }

                            Spacer() // Pushes the content to the left
                        }
                        .padding(.vertical, 8)
                        .listRowInsets(EdgeInsets()) // Remove default padding around the List row
                    }
                    .listStyle(PlainListStyle()) // Use a plain list style to remove default styling (fills the whole page)
                }
            }
            .navigationTitle("My Items") 
        }
    }
}
