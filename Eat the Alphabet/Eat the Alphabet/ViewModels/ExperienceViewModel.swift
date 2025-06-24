//
//  ExperienceViewModel.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//

import Foundation

class ExperienceViewModel: ObservableObject {
    @Published var experience : Experience
    private let repository : ExperienceRepository
    
    init(restaurant: Restaurant, challenge: Challenge, repository: ExperienceRepository) {
        var experience = Experience(
            id: UUID().uuidString,
            users: [],
            restaurant: restaurant,
            challenge: challenge,
            reviews: [],
            date: Date(),
            photoUrls: [])
        self.experience = experience
        self.repository = repository
    }
    
    func createExperience() {
        // FIXME: Call create method from ExperienceRepository
    }
    
    func deleteExperience() {
        // FIXME: Call delete method from ExperienceRepository
    }
    
    func addReview(review : Review) {
        experience.reviews.append(review)
        experience = experience
        // FIXME: Call update method from ExperienceRepository
    }
    
    func removeReview(reviewId : String) {
        experience.reviews.removeAll { $0.id == reviewId }
        experience = experience
        // FIXME: Call update method from ExperienceRepository
    }
    
    func addPhoto(url: String) {
        experience.photoUrls.append(url)
        experience = experience
        // FIXME: Call update method from ExperienceRepository
    }
    
    func removePhoto(url: String) {
        experience.photoUrls.removeAll { $0 == url }
        experience = experience
        // FIXME: Call update method from ExperienceRepository
    }
    
}

