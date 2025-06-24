//
//  ChallengeListViewModel.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/24/25.
//
import Foundation

class ChallengeListViewModel: ObservableObject {
    @Published var challengeViewModels : [ChallengeViewModel] = []
    // TODO: Consider monitoring loading status/errors with other published vars?
    
    private let challengeRepository: ChallengeRepository
    private let experienceRepository: ExperienceRepository
    private let userRepository: UserRepository
    private let userId: String
    
    init(challengeRepository: ChallengeRepository, experienceRepository: ExperienceRepository, userRepository: UserRepository, userId: String) {
        self.challengeRepository = challengeRepository
        self.experienceRepository = experienceRepository
        self.userRepository = userRepository
        self.userId = userId
    }
    
    @MainActor
    func loadChallenges() async {
        // Would place monitoring/error stuff here
        let challenges = await challengeRepository.fetchAllChallenges(for: userId)
        self.challengeViewModels = challenges.map{ ChallengeViewModel(challenge: $0, challengeRepository: challengeRepository, experienceRepository: experienceRepository, userRepository: userRepository) }
    }
    
}
