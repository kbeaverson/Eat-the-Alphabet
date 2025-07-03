//
//  ContentView.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/1/25.
//

import SwiftUI
import Supabase

struct ContentView : View {
    // @EnvironmentObject var appState: AppState
    @State private var checkingSession = true
    @State private var session: Session? = nil
    
    // TODO: change the navigation stack to allow more pages outside of the HomeScreen's tab navigation
    
    var body : some View {
        Group {
            if checkingSession {
                ProgressView("Loading...")
                    .onAppear {
                        Task {
                            do {
                                print("Loading session...")
                                // Load the session when the app starts. If no previous session exist or is expired, we shall navigate to the login screen
                                session = try await supabaseClient.auth.session
                                
                                print("User info: " + String(describing: session?.user))
                                let isExpired = try await supabaseClient.auth.session.isExpired
                                if isExpired {
                                    print("Session expired, navigating to login screen.")
                                } else {
                                    print("Session is valid, navigating to home screen.")
                                }
                                checkingSession = false // finished checking session
                            } catch {
                                print("Error loading session: \(error)")
                                // Handle error, e.g., navigate to login screen
                                checkingSession = false // finished checking session
                            }
                        }
                    }
            } else {
                contentView
            }
        }
    }
    
    var contentView: some View {
        NavigationStack {
            if session == nil { // placeholder
                LoginView(
                    session: $session,
                )
            } else {
                HomeScreen(
                    session: $session,
                )
            }
        }
    }
    
}
