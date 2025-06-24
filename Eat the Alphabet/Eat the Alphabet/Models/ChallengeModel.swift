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
    var participants : [User]
    var experiences : [Experience]
    
    init(id: String, title: String, address: CLLocationCoordinate2D, radius: Float, createDate: Date, participants: [User], experiences: [Experience]) {
        self.id = id
        self.title = title
        self.address = GeoPoint(address)
        self.radius = radius
        self.createDate = createDate
        self.participants = participants
        self.experiences = experiences
    }

}
