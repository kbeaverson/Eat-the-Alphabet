//
//  SwiftUIView.swift
//  Eat the Alphabet
//
//  Created by Will Erkman on 6/8/25.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        TabView {
            Tab("Friends", systemImage: "person.3.fill"){
                FriendsView()
            }
            
            Tab("Challenges", systemImage: "tray.and.arrow.up.fill"){
                ChallengesView()
            }
            
            Tab("Account", systemImage: "person.crop.circle"){
                AccountView()
            }
        }
        .tabViewStyle(.tabBarOnly)
    }
    
    
}


#Preview {
    HomeScreen()
}
