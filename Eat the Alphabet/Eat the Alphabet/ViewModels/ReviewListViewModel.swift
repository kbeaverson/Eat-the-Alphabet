//
//  ReviewListViewModel.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/24/25.
//

import Foundation

class ReviewListViewModel: ObservableObject {
    @Published var reviewViewModels : [ReviewViewModel] = []
    // TODO: Consider monitoring loading status/errors with other published vars?
    
    private let reviewRepository: ReviewRepository = ReviewRepository()
    private let userRepository: UserRepository = UserRepository()
    private let userId: String?
    private let experienceId: String?
    
    init(userId: String?, experienceId: String?) {
        self.userId = userId
        self.experienceId = experienceId
    }
    
    @MainActor
    func loadReviewsForUser() async {
        // Would place monitoring/error stuff here
        guard let userId = userId else { return }
        do {
            let reviews = try await reviewRepository.fetchAllReviewsForUser(for: userId)
            self.reviewViewModels = reviews.map{ ReviewViewModel(review: $0) }
        } catch {
            print("Error fetching reviews for user: \(error)")
        }
    }
    
    @MainActor
    func loadReviewsForExperience() async {
        // Would place monitoring/error stuff here
        guard let experienceId = experienceId else { return }
        do {
            let reviews = try await reviewRepository.fetchAllReviewsForExperience(for: experienceId)
            self.reviewViewModels = reviews.map{ ReviewViewModel(review: $0) }
        } catch {
            print("Error fetching reviews for experience: \(error)")
        }
    }
}
