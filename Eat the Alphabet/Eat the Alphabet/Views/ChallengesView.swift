//
//  ChallengeListView.swift
//  Eat the Alphabet
//
//  Created by Will Erkman on 6/8/25.
//

import SwiftUI
import CoreLocation

struct ChallengesView: View {
    // ViewModel
    private let viewModel = ChallengesViewModel()
    
    @State private var challenges: [Challenge] = []
    
    var body: some View {
        GeometryReader { geo in
            let fieldWidth = geo.size.width * 0.6
            BackgroundScaffold {
                VStack(spacing: 20) {
                    Text("Challenges View")
                    // TODO: pass in real title of challenge
                    // NOTE: @Binging valuemust use a reference to a @State or another @Bingding
                    LazyVStack(spacing: 10) {
                        ForEach(challenges) {
                            challenge in
                            
                        }
                    }
                }
            }
        }
        .onAppear {
        }
        
    }
    func loadChallenges() {
        Task {
            // Fetch challenges when the view appears
            do {
                // TODO:
                try await viewModel.loadChallenges()
            } catch {
                print("Failed to load challenges: \(error)")
            }
        }
    }
}

#Preview {
    ChallengesView()
}
