//
//  CartView.swift
//  iMarket
//
//  Created by Zabdiel Villalobos on 8/27/24.
//

import SwiftUI

struct CartView: View {
    // ObservedObject property wrapper to monitor changes in cartViewModel
    // Updates the view when the data in the view model changes
    @ObservedObject var cartViewModel: CartViewModel
    
    // State variable to track whether the user selected pickup or delivery option
    @State private var isPickup: Bool = true
    
    // State variable to track if the total amount details are expanded
    @State private var isExpanded: Bool = false
    
    var body: some View {
        NavigationView {
            // Vertical stack to layout components from top to bottom
            VStack {
                // HStack for the delivery or pickup selector
                HStack {
                    // Dropdown menu to select between "Pick up" and "Delivery"
                    Menu {
                        Button(action: {
                            isPickup = true // Set to pickup
                        }) {
                            Text("Pick up")
                        }
                        Button(action: {
                            isPickup = false // Set to delivery
                        }) {
                            Text("Delivery")
                        }
                    } label: {
                        // Label for the dropdown menu showing the current selection
                        HStack {
                            Text(isPickup ? "Pick up" : "Delivery")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                            Image(systemName: "chevron.down")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                        }
                    }
                    
                    Text("to")
                        .font(.system(size: 17))
                        .lineSpacing(22)
                        .foregroundColor(Color(red: 235/255, green: 235/255, blue: 245/255, opacity: 0.6)) // Light gray color with opacity
                    
                    Text("Cupertino")
                        .font(.system(size: 16))
                        .lineSpacing(21)
                        .foregroundColor(.white)
                        .bold()
                        .underline()
                    
                    Spacer() // Pushes the content to the left
                }
                .padding() // Padding around the HStack
                
                // List of cart items using data from cartViewModel
                List(cartViewModel.cartItems) { product in
                    // HStack to display each product's image and details side by side
                    HStack {
                        // Asynchronously load an image from a URL
                        AsyncImage(url: URL(string: product.thumbnail)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            // Placeholder color while image loads
                            Color.gray
                        }
                        .frame(width: 40, height: 40)
                        .cornerRadius(8)
                        .clipped()
                        
                        // VStack for product title and price
                        VStack(alignment: .leading) {
                            HStack {
                                // Display the product title
                                Text(product.title)
                                    .font(.system(size: 17))
                                    .lineSpacing(24)
                                    .lineLimit(1)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                // Display the product price
                                Text("$\(product.price, specifier: "%.2f")")
                                    .font(.system(size: 20))
                                    .lineSpacing(24)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Spacer() // Pushes the content to the left
                    }
                }
                .listStyle(PlainListStyle()) // Ensure the list takes up the full width
                
                Spacer() // Flexible space to push content up
                
                // Total amount box with expandable dropdown for more details
                VStack(spacing: 16) {
                    // DisclosureGroup that can expand/collapse
                    DisclosureGroup(isExpanded: $isExpanded) {
                        VStack(alignment: .leading, spacing: 12) { // Container for subtotal, savings, and taxes
                            Divider() // Divider line between items
                                .background(Color.white.opacity(0.5))
                            // Subtotal text showing the sum of prices of items in cart
                            Text("Subtotal: $\(cartViewModel.cartItems.reduce(0) { $0 + $1.price }, specifier: "%.2f")")
                                .foregroundColor(.white)
                            Text("Savings: $0.00")
                                .foregroundColor(.white)
                            Text("Taxes: $0.00")
                                .foregroundColor(.white)
                        }
                        .padding(.top, 8)
                    } label: {
                        // Header of the disclosure group showing the total amount and item count
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                // Display total price of items in the cart
                                Text("Total: $\(cartViewModel.cartItems.reduce(0) { $0 + $1.price }, specifier: "%.2f")")
                                    .font(.system(size: 20))
                                    .lineSpacing(24)
                                    .foregroundColor(.white)
                                
                                // Display number of items in the cart
                                Text("\(cartViewModel.cartItems.count) items")
                                    .font(.system(size: 17))
                                    .lineSpacing(22)
                                    .foregroundColor(Color(red: 235/255, green: 235/255, blue: 245/255, opacity: 0.6)) // Light gray color with opacity
                            }
                            
                            Spacer() // Pushes content to the left
                            
                            // icon indicating if the section is expanded or collapsed
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color(red: 44/255, green: 44/255, blue: 46/255))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal) // padding around the VStack
                    
                    Spacer(minLength: 100) // Flexible space to push content up, with minimum length (allowed for the total and check out to be not next to each other
                    
                    // Checkout button
                    Button(action: {
                    }) {
                        Text("Check Out")
                            .font(.system(size: 17))
                            .lineSpacing(22)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 36)
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                            .background(Color(red: 10/255, green: 132/255, blue: 255/255)) // blue background color
                            .cornerRadius(100)
                    }
                    .padding(.horizontal) // padding around the button
                    .padding(.bottom, 10)
                }
                .navigationTitle("Cart")
                .background(Color.black.edgesIgnoringSafeArea(.all)) // Set a background color for the entire view
            }
        }
    }
}
