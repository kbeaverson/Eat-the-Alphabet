//
//  Eat_the_AlphabetApp.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/1/25.
//

import SwiftUI
import Supabase
import Foundation

@main
struct Eat_the_AlphabetApp: App {
    @StateObject private var appState = AppState()
    
    let supabase = SupabaseClient(supabaseURL: URL(string: "https://nqbccjssatuslwcczbkd.supabase.co")!,  supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5xYmNjanNzYXR1c2x3Y2N6YmtkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwMDQzMzMsImV4cCI6MjA2NDU4MDMzM30.Aeo3cmi9K48Csiw0zmlBcErItpXxQq0Cphisx_WC0Sc")
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(appState)
        }
        .onOpenURL { url in
                    AuthService.shared.handleURL(url) // ✅ forward to helper
                }
    }
}
