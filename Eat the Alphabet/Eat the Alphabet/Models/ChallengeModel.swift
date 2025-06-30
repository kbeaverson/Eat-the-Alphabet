//
//  challenge.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/4/25.
//
import CoreLocation

struct Challenge: Codable, Identifiable {
    let id : String
    var title : String?
    var center_wgs : GeoPoint
    var radius : Float
    let created_at : Date
    var description: String? // Optional description of the challenge
    
    var experiences: [Experience]? = [] // Experiences associated with the challenge
    var letters: [String]? = [] // Letters associated with the challenge
    var participants: [Account]? = [] // Participants associated with the challenge
    
    // TEST: constructor from just data
    init(id: String,
         title: String,
         center_wgs: GeoPoint,
         radius: Float,
         created_at: Date,
         description: String? = nil) {
        self.id = id
        self.title = title
        self.center_wgs = center_wgs
        self.radius = radius
        self.created_at = created_at
        self.description = description
    }
        
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case title = "title"
//        case center_wgs = "center_wgs"
//        case radius = "radius"
//        case created_at = "created_at"
//        case description = "description"
//    }
}
