//
//  ChallengeListViewModel.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/24/25.
//
import Foundation
import SwiftUI

class ChallengeListViewModel: ObservableObject {
    @EnvironmentObject var appState: AppState
    
    @Published var challengeModels : [Challenge] = []
    // TODO: Consider monitoring loading status/errors with other published vars?
    
    private let challengeRepository: ChallengeRepository
    private let experienceRepository: ExperienceRepository
    private let userRepository: AccountRepository
    
    init(challengeRepository: ChallengeRepository, experienceRepository: ExperienceRepository, userRepository: AccountRepository) {
        self.challengeRepository = challengeRepository
        self.experienceRepository = experienceRepository
        self.userRepository = userRepository
    }
    
    @MainActor
    func loadChallenges() async throws {
        do {
            // Would place monitoring/error stuff here
            
//            let challenges = try await challengeRepository.getChallenges(byUserId: appstate.currentUser?.id)
//            self.challengeViewModels = challenges.map{ ChallengeViewModel(challenge: $0, challengeRepository: challengeRepository, experienceRepository: experienceRepository, userRepository: userRepository) }
        }
        catch {
            print("Error loading challenges: \(error)")
            throw error
        }
    }
    
}
