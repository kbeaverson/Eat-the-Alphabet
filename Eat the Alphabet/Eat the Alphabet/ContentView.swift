//
//  ContentView.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/1/25.
//

import SwiftUI

struct ContentView : View {
    @EnvironmentObject var appState: AppState
    
    // TODO: change the navigation stack to allow more pages outside of the HomeScreen's tab navigation
    
    var body : some View {
        NavigationStack {
            if appState.isAuthenticated {
                HomeScreen()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(AppState())
}
