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
    var address: GeoPoint?
    var username: String?
    var display_name: String?
    var profile_image_url: String?
    var phone_number: String?
    
    // TEST: constructor from just data
    init(id: String, created_at: Date, address: GeoPoint? = nil) {
        self.id = id
        self.created_at = created_at
        self.address = address
    }
    
    
    // for simply initializing a User from Supabase's Auth.User
    init(from supabaseUser: Auth.User) {
        self.id = supabaseUser.id.uuidString
        self.created_at = supabaseUser.createdAt
        // NOTE: consider adding a username for @ing NOT NULLABLE
        // NOTE: consider adding a display name NULLABLE
        // NOTE: consider add a profile image URL NULLABLE
        // NOTE: consider adding a phone number NULLABLE
        // NOTE: consider adding a self.email = supabaseUser.email
    }

    enum CodingKeys: String, CodingKey {
        case id
        case created_at
        case address
      }
}


