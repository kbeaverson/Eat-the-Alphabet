//
//  ChallengesView.swift
//  Eat the Alphabet
//
//  Created by Will Erkman on 6/8/25.
//

import SwiftUI
import CoreLocation

// for the ChallengesView, on in 2nd of the root tab navigation
struct ChallengesView: View {
    // ViewModel
    private let viewModel : ChallengeListViewModel = ChallengeListViewModel()
    
    var body: some View {
        GeometryReader { geo in
            let fieldWidth = geo.size.width * 0.6
            BackgroundScaffold {
                VStack(spacing: 20) {
                    // NOTE: @Binging valuemust use a reference to a @State or another @Bingding
                    LazyVStack(spacing: 10) {
                        ForEach(self.viewModel.challenges, id: \.id) { challenge in
                            // TODO: A Challenge List Item class
                            ChallengeListItem(challenge: challenge)
                        }
                    }
                }
            }
        }
        .onAppear {
            loadChallenges()
        }
        
    }
    func loadChallenges() {
        Task {
            // Fetch challenges when the view appears
            do {
                try await viewModel.getChallengesByAccount()
            } catch {
                print("Failed to load challenges: \(error)")
            }
        }
    }
}

#Preview {
    ChallengesView()
}
