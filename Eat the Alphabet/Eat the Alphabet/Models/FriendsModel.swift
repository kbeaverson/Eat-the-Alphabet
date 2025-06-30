//
//  FriendsModel.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/29.
//

import Foundation

struct Friends: Codable {
    let user1_id: String
    let user2_id: String
    let created_at: Date
    var status: String // eg. "pending", "accepted", "rejected", "blocked"
    
    init (user1_id: String, user2_id: String, created_at: Date, status: String) {
        self.user1_id = user1_id
        self.user2_id = user2_id
        self.created_at = created_at
        self.status = status
    }
    
//    enum CodingKeys: String, CodingKey {
//        case user1_id = "user1_id"
//        case user2_id = "user2_id"
//        case created_at = "created_at"
//        case status = "status"
//    }
    
}
