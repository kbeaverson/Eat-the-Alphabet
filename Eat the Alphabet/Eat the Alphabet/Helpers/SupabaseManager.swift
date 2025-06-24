//
//  MockAuthService.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/5.
//

// helper function for supabase authentication
import Supabase
import Foundation

final class SupabaseManager {
    
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        let url = URL(string: Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String ?? "")!
        let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String ?? ""
        self.client = SupabaseClient(supabaseURL: url, supabaseKey: key)
    }
}
