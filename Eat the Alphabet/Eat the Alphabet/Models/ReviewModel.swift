//
//  review.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/9/25.
//

import Foundation

struct Review: Codable, Identifiable {
    let id : String
    var created_at : Date
    var title : String?
    var review : String
    var rating : Int
    var user_id: String
    var experience_id : String
    var order : String
    
    // TEST: constructor from just data
    init (id: String,
          created_at: Date,
          title: String? = nil,
          review: String,
          rating: Int,
          user_id: String,
          experience_id: String,
          order: String) {
        self.id = id
        self.created_at = created_at
        self.title = title
        self.review = review
        self.rating = rating
        self.user_id = user_id
        self.experience_id = experience_id
        self.order = order
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case created_at = "created_at"
        case title = "title"
        case review = "review"
        case rating = "rating"
        case user_id = "user_id"
        case experience_id = "experience_id"
        case order = "order"
    }
}
