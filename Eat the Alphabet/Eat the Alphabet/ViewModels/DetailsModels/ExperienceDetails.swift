//
//  ExperienceDetails.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/30.
//

import Foundation

// experienceDetails structure
struct ExperienceDetails: Identifiable, Codable {
    // experience itself
    let id: String
    let created_at: Date
    var status: String
    
    // experience has foreign key to these
    let challenge: Challenge
    let restaurant: Restaurant
    // these has a foreign key to experience.id
    var participants: [Account]
    var reviews: [Review]
}
