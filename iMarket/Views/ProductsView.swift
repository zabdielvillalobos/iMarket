//
//  ProductsView.swift
//  iMarket
//
//  Created by Zabdiel Villalobos on 8/27/24.
//

import SwiftUI
import Foundation

// remove duplicates from an array
extension Array where Element: Hashable {
    // returns a new array with only unique elements.
    func unique() -> [Element] {
        var seen: Set<Element> = [] // track seen elements.
        return filter { seen.insert($0).inserted } // keep elements that are inserted for the first time.
    }
}

// Custom Button Style to add visual feedback
struct DarkerButtonStyle: ButtonStyle {
    // This function defines how the button looks and behaves.
    func makeBody(configuration: Configuration) -> some View {
        // Use the button's label and apply a background color that changes when the button is pressed.
        configuration.label
            .background(configuration.isPressed ? Color.blue.opacity(0.7) : Color.blue)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed) // Apply a quick animation when pressed.
            .cornerRadius(100) // Round the corners of the button.
            .foregroundColor(.white) // Set the text color to white.
    }
}

// The main view for displaying products.
struct ProductsView: View {
    // Observed objects to react to changes in the view models.
    @ObservedObject var productViewModel: ProductViewModel
    @ObservedObject var cartViewModel: CartViewModel
    @ObservedObject var favoritesViewModel: FavoritesViewModel
    
    // State properties to manage search text and search status.
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    
    // Computed property to filter products based on the search text.
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return productViewModel.products // Return all products if no search text.
        } else {
            return productViewModel.products.filter { product in
                product.title.localizedCaseInsensitiveContains(searchText) ||
                product.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    // Computed property to generate autofill suggestions for the search bar.
    var autofillSuggestions: [String] {
        let categories = productViewModel.products.map { $0.category }.unique().filter {
            $0.localizedCaseInsensitiveContains(searchText)
        }
        let titles = productViewModel.products.map { $0.title }.filter {
            $0.localizedCaseInsensitiveContains(searchText)
        }
        return (categories + titles).prefix(5).sorted() // Limit to the top 5 suggestions.
    }
    
    var body: some View {
        // NavigationView provides a navigation bar and enables pushing new views onto a navigation stack.
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.white) // Set the icon color to white.
                    // TextField to input search text, with a callback for editing state changes.
                    TextField("What are you looking for?", text: $searchText, onEditingChanged: { editing in
                        isSearching = editing
                    })
                    .foregroundColor(Color(red: 235/255, green: 235/255, blue: 245/255, opacity: 0.6)) // Light gray text color.
                }
                .padding(.horizontal, 8) // Add horizontal padding inside the search bar.
                .frame(height: 36) // Set the height of the search bar.
                .background(Color(red: 44/255, green: 44/255, blue: 46/255)) // Dark background color.
                .cornerRadius(100) // Round the corners of the search bar.
                .padding(.horizontal, 10) // Add padding around the search bar.
                .padding(.top) // Add top padding.
                
                // Autofill Dropdown
                if isSearching && !autofillSuggestions.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        // Display each suggestion in the dropdown.
                        ForEach(autofillSuggestions, id: \.self) { suggestion in
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(Color.white) // Set the icon color to white.
                                    .padding(.leading, 10) // Add leading padding for alignment.
                                Text(suggestion)
                                    .foregroundColor(Color(red: 235/255, green: 235/255, blue: 245/255, opacity: 0.6)) // Set the text color.
                                    .onTapGesture {
                                        searchText = suggestion // Set the search text to the selected suggestion.
                                        isSearching = false // End the search.
                                    }
                                    .padding(.leading, 4) // Add leading padding.
                                Spacer()
                            }
                            .padding(.vertical, 4) // Add vertical padding around each suggestion.
                        }
                    }
                    .padding(.horizontal, 10) // Add horizontal padding around the dropdown.
                }
                
                // Display the number of results after search
                if !filteredProducts.isEmpty && !searchText.isEmpty && !isSearching {
                    Text("\(filteredProducts.count) results for \"\(Text(searchText).fontWeight(.bold))\"")
                        .foregroundColor(.white) // Set the text color to white.
                        .padding(.top, 10) // Add top padding.
                }
                
                // Handle different states: loading, error, empty, or displaying products.
                if productViewModel.isLoading {
                    ProgressView("Loading products...") // Show a loading indicator.
                } else if let errorMessage = productViewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red) // Show an error message in red.
                        .padding()
                } else if filteredProducts.isEmpty && !searchText.isEmpty {
                    Spacer() // Add space above the "No Results" message.
                    
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(Color(red: 235/255, green: 235/255, blue: 245/255, opacity: 0.6)) // Set the icon color.
                            .padding(.bottom, 16)
                        
                        Text("No Results")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white) // Set the text color to white.
                        
                        Text("Check the spelling or try a new search")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 235/255, green: 235/255, blue: 245/255, opacity: 0.6)) // Light gray text color.
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40) // Add horizontal padding.
                    }
                    .padding() // Add padding around the "No Results" message.
                    .multilineTextAlignment(.center) // Center-align the text.
                    
                    Spacer() // Add space below the "No Results" message.
                } else {
                    // Display the list of filtered products.
                    List(filteredProducts) { product in
                        HStack {
                            // Load and display the product image asynchronously.
                            AsyncImage(url: URL(string: product.thumbnail)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView() // Show a loading indicator while the image loads.
                                        .frame(width: isSearching ? 40 : 128, height: isSearching ? 40 : 128)
                                        .cornerRadius(8) // Round the corners of the image.
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill() // Scale the image to fill the frame.
                                        .frame(width: isSearching ? 40 : 128, height: isSearching ? 40 : 128)
                                        .cornerRadius(8) // Round the corners of the image.
                                case .failure:
                                    Color.red // Show a red box if the image fails to load.
                                        .frame(width: isSearching ? 40 : 128, height: isSearching ? 40 : 128)
                                        .cornerRadius(8)
                                @unknown default:
                                    EmptyView() // Handle any unknown cases.
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: isSearching ? 4 : 8) {
                                // Display the product title.
                                Text(product.title)
                                    .font(.system(size: 17))
                                    .lineSpacing(22)
                                    .kerning(-0.41)
                                    .lineLimit(1) // Limit the title to one line.
                                    .padding(.bottom, 2)
                                    .foregroundColor(Color(red: 235/255, green: 235/255, blue: 245/255)) // Set the text color.
                                
                                if !isSearching {
                                    // Display the product price.
                                    Text("$\(product.price, specifier: "%.2f")")
                                        .font(.system(size: 20, weight: .bold))
                                        .lineSpacing(24)
                                    
                                    // Display the product category.
                                    Text(product.category.capitalized)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white) // Set the text color to white.
                                        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                        .background(Color(red: 58/255, green: 58/255, blue: 60/255)) // Dark background color.
                                        .cornerRadius(4) // Round the corners of the category label.
                                        .padding(.bottom, 8) // Add bottom padding.
                                    
                                    HStack(spacing: 10) {
                                        // Button to add the product to the cart.
                                        Button(action: {
                                            cartViewModel.addToCart(product: product)
                                        }) {
                                            Text("Add to Cart")
                                                .font(.system(size: 17))
                                                .frame(maxWidth: 173, maxHeight: 36) // Set the button size.
                                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                        }
                                        .buttonStyle(DarkerButtonStyle()) // Apply custom button style.
                                        
                                        // Button to toggle the product as a favorite.
                                        Button(action: {
                                            favoritesViewModel.toggleFavorite(product: product)
                                        }) {
                                            Image(systemName: favoritesViewModel.isFavorite(product: product) ? "heart.fill" : "heart")
                                                .font(.system(size: 17))
                                                .frame(width: 36, height: 36) // Set the button size.
                                                .background(Color(red: 58/255, green: 58/255, blue: 60/255)) // Dark background color.
                                                .cornerRadius(100) // Round the button.
                                                .foregroundColor(.white) // Set the icon color to white.
                                        }
                                    }
                                }
                            }
                            
                            Spacer() // Push the content to the left.
                        }
                        .padding(.vertical, 8) // Add vertical padding around each list item.
                        .listRowInsets(EdgeInsets()) // Remove default padding around the list row.
                    }
                    .listStyle(PlainListStyle()) // Use a plain list style to remove default styling.
                }
            }
            .navigationBarTitleDisplayMode(.inline) // Set the navigation bar title to display inline.
            .onAppear {
                // Fetch the products when the view appears.
                Task {
                    await productViewModel.fetchProducts()
                }
            }
        }
    }
}
