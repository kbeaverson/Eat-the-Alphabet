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
        let url = URL(string: Bundle.main.infoDictionary?["SUPABASE_URL"] as? String ?? "")!
        let key = Bundle.main.infoDictionary?["SUPABASE_ANON_KEY"] as? String ?? ""
        guard !url.absoluteString.isEmpty, !key.isEmpty else {
            fatalError("Supabase URL or Key not set in Info.plist")
        }
        self.client = SupabaseClient(supabaseURL: url, supabaseKey: key)
    }
}
