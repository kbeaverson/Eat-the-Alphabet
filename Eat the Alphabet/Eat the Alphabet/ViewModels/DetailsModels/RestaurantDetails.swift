//
//  RestaurantDetails.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/30.
//

import Foundation

// struct for RestaurantDetails
struct RestaurantDetails: Identifiable, Codable {
    // restaurant itself
    let id: String
    let created_at: Date
    let name: String
    let details: String?
    let cuisine: String?
    let rating: Int?
    let map_imported_rating: Int?
    let avg_per_cost: Int?
    let address_wgs: GeoPoint
    let address_text: String?
    let image_url: String?
    
    // experience has a foriegn key to restaurant
    let experience: Experience
}
