//
//  restaurant.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/4/25.
//
import CoreLocation

class Restaurant {
    let id : Int
    let name : String
    let cuisine : String
    let price : Int
    let rating : Float
    let address : CLLocationCoordinate2D
    
    init(id: Int, name: String, cuisine: String, price: Int, rating: Float, address: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.cuisine = cuisine
        self.price = price
        self.rating = rating
        self.address = address
    }
}
