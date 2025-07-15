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
    @State private var account: Account?
    @State private var isLoading: Bool = true

    var body: some View {
        if isLoading {
            ProgressView("Loading")
                .onAppear {
                    print("Loading home screen")
                    loadAccount()
                }
        } else {
            TabView {
                Tab("Friends", systemImage: "person.3.fill"){
                    FriendsView()
                }
                
                Tab("Challenges", systemImage: "tray.and.arrow.up.fill"){
                    ChallengesView()
                }
                
                Tab("Account", systemImage: "person.crop.circle"){
                    AccountView(session: $session, account: $account)
                }
            }
            .tabViewStyle(.tabBarOnly)
            .onAppear {
                print("Home Screen Appeared")
                let appearance = UITabBarAppearance()
                    appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor.appBackground

                    UITabBar.appearance().standardAppearance = appearance
                    UITabBar.appearance().scrollEdgeAppearance = appearance
            }
            .onDisappear {
                print("Home Screen Disappeared")
            }
        }
    }
    
    private func loadAccount() {
        Task {
            do {
                guard let session = session else {
                    print("No valid session or user ID found")
                    await MainActor.run {
                        self.isLoading = false
                    }
                    return
                }
                let id = session.user.id.uuidString
                print("ID found in session: \(id)")
                let fetchedAccount = try await AccountRepository.shared.fetchAccount(byId: id)
                await MainActor.run {
                    self.account = fetchedAccount
                    self.isLoading = false
                }
            } catch {
                print("Error loading account: \(error)")
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
}
#Preview {
    HomeScreen(session: .constant(nil))
}
