//
//  ExperienceParticipant.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/24/25.
//

struct ExperienceParticipant: Codable {
    let userID: String
    let experienceID: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case experienceID = "experience_id"
    }
}
