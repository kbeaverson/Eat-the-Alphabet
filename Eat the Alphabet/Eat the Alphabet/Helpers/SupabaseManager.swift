//
//  MockAuthService.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/5.
//

// helper function for supabase authentication
import Supabase
import Foundation

// SupabaseManager is unnecessary and @deprecated, the supabaseClient is exposed to the application
let url = URL(string: Bundle.main.infoDictionary?["SUPABASE_URL"] as? String ?? "")!
let key = Bundle.main.infoDictionary?["SUPABASE_ANON_KEY"] as? String ?? ""

let supabaseClient = SupabaseClient(supabaseURL: url, supabaseKey: key)
