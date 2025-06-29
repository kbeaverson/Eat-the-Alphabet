//
//  ChallengeParticipant.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/24/25.
//

struct ChallengeParticipant: Codable {
    let userID: String
    let challengeID: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case challengeID = "challenge_id"
    }
}
