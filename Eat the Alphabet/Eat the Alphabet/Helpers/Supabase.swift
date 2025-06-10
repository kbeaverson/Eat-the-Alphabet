//
//  Supabase.swift
//  Eat the Alphabet
//
//  Created by Will Erkman on 6/9/25.
//


import Foundation
import Supabase
//let url = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL")

let supabase = SupabaseClient(
    supabaseURL: URL(string: "https://nqbccjssatuslwcczbkd.supabase.co")!,
  supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5xYmNjanNzYXR1c2x3Y2N6YmtkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwMDQzMzMsImV4cCI6MjA2NDU4MDMzM30.Aeo3cmi9K48Csiw0zmlBcErItpXxQq0Cphisx_WC0Sc"
)
