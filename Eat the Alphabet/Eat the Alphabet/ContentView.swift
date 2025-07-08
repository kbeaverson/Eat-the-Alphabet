//
//  ContentView.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/1/25.
//

import SwiftUI
import Supabase

struct ContentView : View {
    @State private var checkingSession = true
    @State private var session: Session? = nil
    
    // TODO: change the navigation stack to allow more pages outside of the HomeScreen's tab navigation
    
    var body : some View {
        Group {
            if checkingSession {
                ProgressView("Loading...")
            } else {
                contentView
            }
        }
        .onAppear {
            Task {
                do {
                    print("Loading session...")
                    let loadedSession = try await supabaseClient.auth.session
                    let isExpired = try await supabaseClient.auth.session.isExpired
                    await MainActor.run {
                        session = isExpired ? nil : loadedSession
                        checkingSession = false
                    }
                } catch {
                    print("Error loading session: \(error)")
                    await MainActor.run {
                        session = nil
                        checkingSession = false
                    }
                }
            }
        }
    }
    
    var contentView: some View {
        NavigationStack {

            if (session == nil) {
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
