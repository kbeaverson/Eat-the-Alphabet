//
//  experience.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/4/25.
//
import Foundation
import SwiftUICore

class Experience {
    let id : String
    var users : [User]
    var restaurant : Restaurant
    let challenge : Challenge
    var reviews : [Review]
    var date : Date
    let letter : Character
    var photos : [Image]
    
    init(id: String, users: [User], restaurant: Restaurant, challenge: Challenge, reviews: [Review], date: Date, letter: Character, photos: [Image]) {
        self.id = id
        self.users = users
        self.restaurant = restaurant
        self.challenge = challenge
        self.reviews = reviews
        self.date = date
        self.letter = letter // NOTE: probably not necessary (can be inferred from the restaurant name)
        self.photos = photos // NOTE: consider changing into list of URLs instead of Image objects, or a review_images [id: UUID, review_id: UUID, imageUrl: text] table
    }
    
//    func addPhoto(_ photo: Image) {
//        self.photos.append(photo)
//    }
//    
//    func removePhoto(at index: Int) {
//        self.photos.remove(at: index)
//    }
//    
//    func addReview(_ review: Review) {
//        self.reviews.append(review)
//    }
//    
//    func addUser(_ user: User) {
//        self.users.append(user)
//    }
}
