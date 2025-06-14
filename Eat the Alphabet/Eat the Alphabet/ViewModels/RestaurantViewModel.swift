//
//  RestaurantViewModel.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/14.
//

struct RestaurantViewModel: Identifiable, Decodable {
    let id: String
    let name: String
    let cuisine: String
    let distance: String
    let imageUrl: String
    let details: String
    // image color tint is calculated from the image
}
