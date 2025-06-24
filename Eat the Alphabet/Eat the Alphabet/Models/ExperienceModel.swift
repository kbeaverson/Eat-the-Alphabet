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
    var photoUrls : [String]
    
    init(id: String, users: [User], restaurant: Restaurant, challenge: Challenge, reviews: [Review], date: Date, photoUrls: [String]) {
        self.id = id
        self.users = users
        self.restaurant = restaurant
        self.challenge = challenge
        self.reviews = reviews
        self.date = date
        self.photoUrls = photoUrls
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
