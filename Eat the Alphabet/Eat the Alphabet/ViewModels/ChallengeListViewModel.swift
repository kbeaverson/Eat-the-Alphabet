//
//  ChallengeListViewModel.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/24/25.
//
import Foundation
import SwiftUI

// for the ChallengesView, on in 2nd of the root tab navigation
class ChallengeListViewModel: ObservableObject {
    // @EnvironmentObject var appState: AppState
    
    @Published var challenges : [Challenge] = []
    // TODO: Consider monitoring loading status/errors with other published vars?
    
    private let challengeRepository: ChallengeRepository
    private let experienceRepository: ExperienceRepository
    private let userRepository: AccountRepository
    
    init() {
        self.challengeRepository = ChallengeRepository()
        self.experienceRepository = ExperienceRepository()
        self.userRepository = AccountRepository()
    }
    
    @MainActor
    public func getChallengesByAccount() async throws {
        // guard the current authenticated user exists
        guard let user = supabaseClient.auth.currentUser else {
            print ("No authenticated user found.")
            throw NSError(domain: "ChallengesViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found."])
        }
        
        do {
            // Would place monitoring/error stuff here
            let challenges = try await challengeRepository.fetchChallenges(byUser: user.id.uuidString)
            self.challenges = challenges.map{ $0 }
        }
        catch {
            print("Error loading challenges: \(error)")
            throw error
        }
    }
}
