//
//  experience.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/4/25.
//
import Foundation
import SwiftUICore

struct Experience: Identifiable, Codable {
    let id : String
    let created_at : Date
    var status : String
    let restaurant_id : String
    let challenge_id : String
    let letter: String
    
    var reviews: [Review]? = []
    var participants: [Account]? = [] // Participants associated with the experience
    var restaurant: Restaurant? = nil // Restaurants associated with the experience
    
    init (id: String,
          created_at: Date,
          status: String = "incomplete",
          restaurant_id: String,
          challenge_id: String,
          letter: String
    ) {
        self.id = id
        self.created_at = created_at
        self.status = status
        self.restaurant_id = restaurant_id
        self.challenge_id = challenge_id
        self.letter = letter
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case created_at = "created_at"
        case status = "status"
        case restaurant_id = "restaurant_id"
        case challenge_id = "challenge_id"
        case letter = "letter"
        
        case reviews = "Review"
        case participants = "Account"
        case restaurant = "Restaurant"
    }
}
