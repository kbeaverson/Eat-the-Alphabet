//
//  review.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/9/25.
//

import Foundation

struct Review: Codable, Identifiable {
    let user : User
    let id : String
    var date : Date
    var review : String
    var rating : Int
    var order : String
    
    init(user: User, id: String, date: Date, review: String, rating: Int, order: String) {
        self.user = user
        self.id = id
        self.date = date
        // NOTE: consier adding a title? (Eg. App Store reviews) NOT NULLABLE
        self.review = review
        self.rating = rating
        self.order = order // NOTE: what is this? The ordered food items?
    }
}
