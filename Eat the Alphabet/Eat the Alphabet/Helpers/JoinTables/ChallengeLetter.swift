//
//  ChallengeLetter.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/29.
//

struct ChallengeLetter: Codable {
    let challengeId: String
    let letter: String
    
    enum CodingKeys: String, CodingKey {
        case challengeId = "challenge_id"
        case letter = "letter"
    }
}
    
    
