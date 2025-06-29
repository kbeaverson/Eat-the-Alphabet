//
//  FriendsModel.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/29.
//

import Foundation

struct Friends: Codable {
    let user_id1: String
    let user_id2: String
    let created_at: Date
    var status: String // eg. "pending", "accepted", "rejected", "blocked"
    
    init (user_id1: String, user_id2: String, created_at: Date, status: String) {
        self.user_id1 = user_id1
        self.user_id2 = user_id2
        self.created_at = created_at
        self.status = status
    }
    
    enum CodingKeys: String, CodingKey {
        case user_id1 = "user_id1"
        case user_id2 = "user_id2"
        case created_at = "created_at"
        case status = "status"
    }
        
