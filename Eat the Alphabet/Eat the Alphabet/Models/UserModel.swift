//
//  UserModel.swift
//  Eat the Alphabet
//
//  Created by Will Erkman on 6/9/25.
//
import Supabase
import Foundation

struct User: Codable {
    let id: String
    let created_at: String?
    let address: String?
    
    // Added by Liao
    init(from supabaseUser: Auth.User) {
        self.id = supabaseUser.id.uuidString
        // self.email = supabaseUser.email
        self.created_at = nil
        self.address = nil
    }

    
    enum CodingKeys: String, CodingKey {
        case id
        case created_at
        case address
      }
}


