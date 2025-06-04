//
//  MainView.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/4.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            Text("Welcome to Eat the Alphabet!")
                .font(.title)
            Button("Log out") {
                appState.isAuthenticated = false
            }
        }
        .padding()
        .onAppear { print("MainPageView appeared") }
    }
}
