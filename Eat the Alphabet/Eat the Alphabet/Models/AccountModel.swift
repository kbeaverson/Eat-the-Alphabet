//
//  UserModel.swift
//  Eat the Alphabet
//
//  Created by Will Erkman on 6/9/25.
//

/**
 REMINDER: This model has a View remotely
 
 CREATE OR REPLACE VIEW public."AccountWithWKT" AS
 SELECT
   id,
   created_at,
   ST_AsText(address_wgs)    AS address_wgs,
   username,
   display_name,
   profile_image_url,
   phone_number,
   email
 FROM public."Account";
 */
import Supabase
import Foundation

struct Account: Codable, Identifiable {
    let id: String
    let created_at: Date
    var address_wgs: String? //FIXME: GeoPoint?
    var username: String?
    var display_name: String?
    var profile_image_url: String?
    var phone_number: String?
    var email: String // Supabase Auth User's email, NOT NULLABLE
    
    var reviews: [Review]? = nil // reviews made by this user
    var challenges: [Challenge]? = nil // challenges created by this user
    var experiences: [Experience]? = nil // experiences created by this user
    
    var friends: [Friends]? = nil // user1_id or user2_id == user.id
    
    // TEST: constructor from just data
    init(id: String,
         created_at: Date,
         address_wgs: String? = nil,
         username: String,
         display_name: String? = nil,
         profile_image_url: String? = nil,
         phone_number: String? = nil,
         email: String) {
        self.id = id
        self.created_at = created_at
        self.address_wgs = address_wgs
        self.username = username
        self.display_name = display_name
        self.profile_image_url = profile_image_url
        self.phone_number = phone_number
        self.email = email
    }
    
    
    // for simply initializing a User from Supabase's Auth.User
    init(from supabaseUser: Auth.User) {
        self.id = supabaseUser.id.uuidString
        self.created_at = supabaseUser.createdAt
        self.email = supabaseUser.email ?? "" // Supabase Auth User's email, NOT NULLABLE
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
        case email = "email"
        
        case reviews = "Review"
        case challenges = "Challenge"
        case experiences = "Experience"
    }
}


