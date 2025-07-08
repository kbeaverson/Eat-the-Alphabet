//
//  ChallengeListItem.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/7/8.
//

import SwiftUI

struct ChallengeListItem: View {
    let challenge: Challenge // PASSED IN
    
    private let viewModel: ChallengeViewModel
    
    init(challenge: Challenge) {
        self.challenge = challenge
        self.viewModel = ChallengeViewModel(challenge: challenge)
    }

    var body: some View {
        NavigationLink(destination: ExperienceListView(challenge: challenge)) {
            HStack {
                Text(challenge.title ?? "Untitled Challenge")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.leading, 16)
                Spacer()
            }
            .frame(height: 60)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle()) // 保证外观不变
    }
}
