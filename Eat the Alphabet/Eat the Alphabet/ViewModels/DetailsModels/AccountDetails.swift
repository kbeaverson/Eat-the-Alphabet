//
//  AccountDetails.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/30.
//

import Foundation

struct AccountDetails: Identifiable, Codable {
    let id: String
    let created_at: Date
    var username: String
    var phone_number: String?
    var display_name: String?
    var address_wgs: GeoPoint?
    var profile_image_url: String?
    
    // tables with a foreign key to the user
    var challenges: [Challenge]
    var experiences: [Experience]
    var reviews: [Review]
    
    var sentFriendRequests: [Account]       // user1_id == user.id
    var receivedFriendRequests: [Account]   // user2_id == user.id
}
