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
    var users : [User]
    var restaurant : Restaurant
    let challenge : Challenge
    var reviews : [Review]
    var date : Date
    // let letter : Character // NOTE: consider removing this can be inferred from the restaurant name
    var photo_urls : [String]
    
    // TEST: constructor from just data
//    init(id: String, users: [User], restaurant: Restaurant, challenge: Challenge, reviews: [Review], date: Date /**, letter: Character*/, photoUrl: [String]) {
//        self.id = id
//        self.users = users
//        self.restaurant = restaurant
//        self.challenge = challenge
//        self.reviews = reviews
//        self.date = date
//        // self.letter = letter // NOTE: probably not necessary (can be inferred from the restaurant name)
//        self.photoUrl = photoUrl // NOTE: consider changing into list of URLs instead of Image objects, or a review_images [id: UUID, review_id: UUID, imageUrl: text] table
//    }
}
