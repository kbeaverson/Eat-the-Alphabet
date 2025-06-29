//
//  ChallengeDetails.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/30.
//

import Foundation
import CoreLocation

// structure for a detailed challenge view
struct ChallengeDetails: Identifiable, Codable {
    // the challenge itself
    let id: String
    let created_at: Date
    var title: String?
    var description: String?
    let center_wgs: GeoPoint
    let radius: Float
    
    // the tables that has a foreign key to the challenge
    // the experiences associated with the challenge
    var experiences: [Experience]
    // the participants associated with the challenge via Join Table Challenge_Participant
    var participants: [Account]
    // the letters associated with the challenge via the Challenge_Letter table
    var letter: [String]
    // the restaurants associated with the challenge will be inferred frm the experiences.restaurant_id
}
