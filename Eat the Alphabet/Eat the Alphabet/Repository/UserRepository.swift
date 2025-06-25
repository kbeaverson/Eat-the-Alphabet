//
//  UserRepository.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//

import Foundation
import Supabase

class UserRepository  {
    let supabase = SupabaseManager.shared.client
    
    // Fetch User by username
    func fetchUser(username: String) async -> User? {
        let user: User? = try? await supabase
            .from("users")
            .select("username")
            .eq("username", value: username)
            .execute().value
        return user
    }
    
    // Fetch User by id
    func fetchUser(userid: String) async -> User? {
        let user: User? = try? await supabase
            .from("users")
            .select("username")
            .eq("id", value: userid)
            .execute().value
        return user
    }
    
    // Edit User
    func editUser(user: User) async -> Void {
        try? await supabase
            .from("users")
            .update(user)
            .eq("id", value: user.id)
            .execute().value
    }
    
    // Delete User
    
}

