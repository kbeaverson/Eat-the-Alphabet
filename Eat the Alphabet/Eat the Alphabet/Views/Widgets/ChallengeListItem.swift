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
    
    @Binding var isSelected: Bool
    var isSelectionModeOn: Bool = false
    // var onTap: (() -> Void)? = nil
    
    @State private var isParticipated: Bool? = nil // Track if the user has participated
    
    init(
        challenge: Challenge,
        isSelected: Binding<Bool>,
        isSelectionModeOn: Bool = false,
        // onTap: (() -> Void)? = nil
    ) {
        self.challenge = challenge
        self.viewModel = ChallengeViewModel(challenge: challenge)
        self._isSelected = isSelected
        self.isSelectionModeOn = isSelectionModeOn
        // self.onTap = onTap
    }

    var body: some View {
        NavigationLink(destination: ExperienceListView(challenge: challenge)) {
            ZStack(alignment: .topLeading) {
                HStack {
                    Text(challenge.title ?? "Untitled Challenge")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.defaultText)
                        .padding(.leading, 16)
                    Spacer()
                    if isSelectionModeOn {
                        Toggle("", isOn: $isSelected)
                            .toggleStyle(CheckboxToggleStyle())
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 12)
                    }
                }
                .frame(height: 60)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .background(.clear)
            .cornerRadius(12)
//            .onTapGesture {
//                if !isSelectionModeOn {
//                    onTap?()
//                }
//            }
        }
        .contextMenu {
            if let isParticipated = isParticipated {
                Button(action: {
                    // TODO: Leave the challenge or join
                    Task {
                        if isParticipated {
                            do {
                                try await viewModel.leaveChallenge(
                                    userId: supabaseClient.auth.user().id.uuidString,
                                    challengeId: challenge.id
                                )
                                
                                await MainActor.run {
                                    self.isParticipated = false
                                }
                            } catch {
                                print ("Error leaving challenge: \(error.localizedDescription)")
                            }
                        } else {
                            do {
                                try await viewModel.joinChallenge(
                                    userId: supabaseClient.auth.user().id.uuidString,
                                    challengeId: challenge.id
                                )
                                await MainActor.run {
                                    self.isParticipated = true
                                }
                            } catch {
                                print("Error joining challenge: \(error.localizedDescription)")
                            }
                        }
                    }
                }) {
                    if isParticipated {
                        Label("Leave Challenge", systemImage: "trash")
                            .foregroundStyle(.red)
                    }else {
                        Label("Join Challenge", systemImage: "plus")
                            .foregroundStyle(.green)
                    }
                }
            }
        }
        .onAppear {
            Task {
                // Check if the user has participated in the challenge
                let participated = await getIfParticipated(challengeId: challenge.id) ?? nil
                await MainActor.run {
                    isParticipated = participated
                }
            }
        }
        .buttonStyle(PlainButtonStyle()) // 保证外观不变
    }
    
    func getIfParticipated(challengeId: String) async -> Bool? {
        do {
            return try await viewModel.getIfParticipated(
                userId: supabaseClient.auth.user().id.uuidString,
                challengeId: challengeId
            )
        } catch {
            print("Error checking participation: \(error.localizedDescription)")
            return nil
        }
    }
}
