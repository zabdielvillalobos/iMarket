//
//  ProductViewModel.swift
//  iMarket
//
//  Created by Zabdiel Villalobos on 8/27/24.
//

import Foundation

// class is responsible for managing the list of products and fetching them from a server.
// REMINDER: uses ObservableObject protocol so that SwiftUI views can listen for changes.
class ProductViewModel: ObservableObject {
    
    // holds the list of products. when it changes, any view observing this will update automatically.
    @Published var products: [Product] = []
    
    // tracks whether data is currently being loaded. useful for showing a loading spinner.
    @Published var isLoading: Bool = false
    
    // stores any error messages that might occur during data fetching.
    @Published var errorMessage: String?

    // function is responsible for fetching product data from a remote server.
    // uses async/await to handle the network request asynchronously.
    func fetchProducts() async {
        // first, we make sure the URL is valid. If it's not, we set an error message and stop here. tried to be cool and do some error handling ;o
        guard let url = URL(string: "https://dummyjson.com/products") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
            }
            return
        }

        // set the loading state to true and clear any old error messages. Do this on the main thread to keep the UI in sync.
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }

        do {
            // try to fetch data from the URL. This might throw an error if the network request fails.
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // try to decode the JSON data into a ProductResponse object. This might throw an error if the data isn't formatted correctly.
            let productResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
            
            // if everything works, update the list of products and stop showing the loading indicator.
            DispatchQueue.main.async {
                self.products = productResponse.products
                self.isLoading = false
            }
        } catch {
            // if something went wrong (either fetching or decoding), show an error message and stop the loading indicator.
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
        }
    }
}


