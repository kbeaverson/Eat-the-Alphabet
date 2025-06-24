//
//  UserModel.swift
//  Eat the Alphabet
//
//  Created by Will Erkman on 6/9/25.
//
import Supabase
import Foundation

struct User: Codable, Identifiable {
    let id: String?
    let created_at: String?
    let address: String?
    
    // Added by Liao
    init(from supabaseUser: Auth.User) {
        self.id = supabaseUser.id.uuidString
        self.created_at = nil
        // NOTE: consider adding a username for @ing NOT NULLABLE
        // NOTE: consider adding a display name NULLABLE
        // NOTE: consider add a profile image URL NULLABLE
        // NOTE: consider adding a phone number NULLABLE
        // NOTE: consider adding a self.email = supabaseUser.email NULLABLE
        self.address = nil
    }

    
    enum CodingKeys: String, CodingKey {
        case id
        case created_at
        case address
      }
}


