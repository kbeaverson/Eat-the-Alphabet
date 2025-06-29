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
    var created_at : Date
    var status : String
    var restaurant_id : String
    let challenge_id : String
    
    init (id: String,
          created_at: Date,
          status: String="incomplete",
          restaurant_id: String,
          challenge_id: String) {
        self.id = id
        self.created_at = created_at
        self.status = status
        self.restaurant_id = restaurant_id
        self.challenge_id = challenge_id
    }
            
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case created_at = "created_at"
        case status = "status"
        case restaurant_id = "restaurant_id"
        case challenge_id = "challenge_id"
    }
}
