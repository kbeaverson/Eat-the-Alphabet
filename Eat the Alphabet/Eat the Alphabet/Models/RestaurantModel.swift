//
//  restaurant.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/4/25.
//
import CoreLocation

class Restaurant {
    let id : String
    let name : String
    let cuisine : String
    let price : Int
    let rating : Float
    let address : CLLocationCoordinate2D // NOTE: change to 'coord' instead, address is a little misleading?
    // NOTE: consider add address as a string
    let details : String? // PLACEHOLDER
    // NOTE: consider add image's url if there is one NULLABLE
    let imageUrl : String? // PLACEHOLDER
    
    init(id: String, name: String, cuisine: String, price: Int, rating: Float, address: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.cuisine = cuisine
        self.price = price
        self.rating = rating
        self.address = address
        // NOTE: replace with real data by adding columns
        self.imageUrl = "https://cdn.eathappyproject.com/wp-content/uploads/2021/10/Chinese-Cuisine.jpg"
        self.details = "This is a placeholder restaurant description. Please replace it with actual details. Random text start: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    }
}
