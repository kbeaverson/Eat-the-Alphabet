//
//  ExperienceListViewModel.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/24/25.
//
import Foundation

class ExperienceListViewModel: ObservableObject {
    @Published var experienceViewModels : [ExperienceViewModel] = []
    // TODO: Consider monitoring loading status/errors with other published vars?
    
    private let reviewRepository: ReviewRepository
    private let experienceRepository: ExperienceRepository
    private let userRepository: UserRepository
    private let userId: String
    
    init(reviewRepository: ReviewRepository, experienceRepository: ExperienceRepository, userRepository: UserRepository, userId: String) {
        self.reviewRepository = reviewRepository
        self.experienceRepository = experienceRepository
        self.userRepository = userRepository
        self.userId = userId
    }
    
    @MainActor
    func loadExperiences() async {
        // Would place monitoring/error stuff here
        do {
            let experiences = try await experienceRepository.fetchAllExperiences(for: userId)
            self.experienceViewModels = experiences.map{ ExperienceViewModel(restaurant: $0.restaurant, challenge: $0.challenge, repository: experienceRepository, userRepository: userRepository, reviewRepository: reviewRepository) }
        } catch {
            print("Error fetching experiences: \(error)")
        }
    }
}
