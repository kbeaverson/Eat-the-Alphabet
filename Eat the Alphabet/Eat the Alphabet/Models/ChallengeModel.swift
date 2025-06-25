//
//  challenge.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/4/25.
//
import CoreLocation

struct Challenge: Codable, Identifiable {
    let id : String
    var title : String
    var address : GeoPoint
    var radius : Float
    let createDate : Date
    var restaurants : [Restaurant]
    var participants : [User]
    var experiences : [Experience]
    // var remainingLetters : [Character]
    
    // TEST: constructor from just data
//    init(id: String, title: String, address: CLLocationCoordinate2D, radius: Float, createDate: Date, restaurants: [Restaurant], participants: [User], experiences: [Experience] /**, remainingLetters: [Character]*/) {
//        self.id = id
//        self.title = title
//        self.address = GeoPoint(address)
//        self.radius = radius
//        self.createDate = createDate
//        self.restaurants = restaurants
//        self.participants = participants
//        self.experiences = experiences
//        // self.remainingLetters = remainingLetters // NOTE: this can be inferred from another table (potentially "challenges_restaurants", etc.), instead of using a list of characters
//    }

}
