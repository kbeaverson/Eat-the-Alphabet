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
        // guard the current authenticated user exists
        guard let user = appState.currentAuthUser else {
            print ("No authenticated user found.")
            throw NSError(domain: "ChallengeListViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found."])
        }
        
        do {
            // Would place monitoring/error stuff here
            let challenges = try await challengeRepository.getChallenges(byUserId: user.id.uuidString)
            self.challengeModels = challenges.map{ $0 }
        }
        catch {
            print("Error loading challenges: \(error)")
            throw error
        }
    }
    
}
