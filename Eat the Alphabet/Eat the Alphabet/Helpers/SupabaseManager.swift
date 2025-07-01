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
//        let url = URL(string: Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String ?? "")!
//        let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String ?? ""
        let url = URL(string: "https://nqbccjssatuslwcczbkd.supabase.co")!
        let key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5xYmNjanNzYXR1c2x3Y2N6YmtkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwMDQzMzMsImV4cCI6MjA2NDU4MDMzM30.Aeo3cmi9K48Csiw0zmlBcErItpXxQq0Cphisx_WC0Sc"
        self.client = SupabaseClient(supabaseURL: url, supabaseKey: key)
    }
}
