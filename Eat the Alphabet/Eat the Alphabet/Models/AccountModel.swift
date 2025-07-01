//
//  UserModel.swift
//  Eat the Alphabet
//
//  Created by Will Erkman on 6/9/25.
//
import Supabase
import Foundation

struct Account: Codable, Identifiable {
    let id: String
    let created_at: Date
    var address_wgs: GeoPoint?
    var username: String?
    var display_name: String?
    var profile_image_url: String?
    var phone_number: String?
    
    var reviews: [Review]? = [] // reviews made by this user
    var challenges: [Challenge]? = [] // challenges created by this user
    var experiences: [Experience]? = [] // experiences created by this user
    
    var friends: [Friends]? = [] // user1_id or user2_id == user.id
    
    // TEST: constructor from just data
    init(id: String,
         created_at: Date,
         address_wgs: GeoPoint? = nil,
         username: String,
         display_name: String? = nil,
         profile_image_url: String? = nil,
         phone_number: String? = nil) {
        self.id = id
        self.created_at = created_at
        self.address_wgs = address_wgs
        self.username = username
        self.display_name = display_name
        self.profile_image_url = profile_image_url
        self.phone_number = phone_number
    }
    
    
    // for simply initializing a User from Supabase's Auth.User
    init(from supabaseUser: Auth.User) {
        self.id = supabaseUser.id.uuidString
        self.created_at = supabaseUser.createdAt
        // TODO: must get username from database
        // NOTE: consider add a profile image URL NULLABLE
        // NOTE: consider adding a phone number NULLABLE
        // NOTE: consider adding a self.email = supabaseUser.email
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case created_at = "created_at"
        case address_wgs = "address_wgs"
        case username = "username"
        case display_name = "display_name"
        case profile_image_url = "profile_image_url"
        case phone_number = "phone_number"
    }
}


