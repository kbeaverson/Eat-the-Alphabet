//
//  SwiftUIView.swift
//  Eat the Alphabet
//
//  Created by Will Erkman on 6/8/25.
//

import SwiftUI
import Supabase

struct HomeScreen: View {
    @Binding var session: Session?
    var body: some View {
        TabView {
            Tab("Friends", systemImage: "person.3.fill"){
                FriendsView()
            }
            
            Tab("Challenges", systemImage: "tray.and.arrow.up.fill"){
                ChallengesView()
            }
            
            Tab("Account", systemImage: "person.crop.circle"){
                AccountView(session: $session)
            }
        }
        .tabViewStyle(.tabBarOnly)
        .onAppear {
            print("Home Screen Appeared")
        }
        .onDisappear {
            print("Home Screen Disappeared")
        }
    }
        
    
    
}
#Preview {
    HomeScreen(session: .constant(nil))
}
