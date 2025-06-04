//
//  ContentView.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/1/25.
//

import SwiftUI

struct ContentView : View {
    @EnvironmentObject var appState: AppState
    
    var body : some View {
        NavigationStack {
            if appState.isAuthenticated {
                MainView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(AppState())
}
