//
//  restaurant.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/4/25.
//
import CoreLocation

// NOTE: changed to struct, original Restaurant model, 不含业务逻辑、不含 UI 信息、不处理数据库访问。
struct Restaurant: Codable, Identifiable {
    let id : String
    let name : String
    let cuisine : String
    let price : Int
    let rating : Float
    let address : CLLocationCoordinate2D // FIXME: consider change to 'coord' instead, address is a little misleading?
    // FIXME: consider add address as a string
    let details : String? // PLACEHOLDER
    // FIXME: consider add image's url if there is one NULLABLE
    let imageUrl : String? // PLACEHOLDER
    
    // TEST: constructor from just data
    init(id: String, name: String, cuisine: String, price: Int, rating: Float, address: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.cuisine = cuisine
        self.price = price
        self.rating = rating
        self.address = address
        // FIXME: replace with real data by adding columns
        self.imageUrl = "https://cdn.eathappyproject.com/wp-content/uploads/2021/10/Chinese-Cuisine.jpg"
        self.details = "This is a placeholder restaurant description. Please replace it with actual details. Random text start: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    }
}
