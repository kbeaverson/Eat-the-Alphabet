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
    @Environment(\.scenePhase) private var scenePhase
    
    // request permission
    @StateObject private var permissionManager = PermissionManager.shared

    // app state management
    // @StateObject private var appState = AppState()
    
    // let supabase = SupabaseClient(supabaseURL: URL(string: "https://nqbccjssatuslwcczbkd.supabase.co")!,  supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5xYmNjanNzYXR1c2x3Y2N6YmtkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwMDQzMzMsImV4cCI6MjA2NDU4MDMzM30.Aeo3cmi9K48Csiw0zmlBcErItpXxQq0Cphisx_WC0Sc")
    
    init() {
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in supabaseClient.auth.handle(url) /* forward to helper */ }
                // .environmentObject(appState)
                .environmentObject(permissionManager)
        }
//        .onChange(of: scenePhase) { newPhase in
//            switch newPhase {
//            case .active:
//                print("App became active")
//            case .inactive:
//                print("App became inactive")
//            case .background:
//                print("App moved to background")
//            @unknown default:
//                print("Unknown app state")
//            }
//        }
    }
}
