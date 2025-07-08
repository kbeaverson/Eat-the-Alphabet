//
//  ExperienceViewModel.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//

import Foundation

class ExperienceViewModel: ObservableObject {
    
    @Published var experience : Experience?
    
    private let repository : ExperienceRepository
    private let accountRepository : AccountRepository
    private let reviewRepository : ReviewRepository
    
    init() {
        self.repository = ExperienceRepository()
        self.accountRepository = AccountRepository()
        self.reviewRepository = ReviewRepository()
    }
    // FIXME
    
    // fetch experience by challenge_id

//    func createExperience() async {
//        do {
//            try await repository.createExperience(experience: self.experience)
//        } catch {
//            print("Error creating experience: \(error)")
//        }
//    }
//    
//    func deleteExperience() async {
//        do {
//            try await repository.deleteExperience(experience: self.experience)
//        } catch {
//            print("Error deleting experience: \(error)")
//        }
//    }
//    
//    func addReview(review : Review) async {
//        experience.reviews.append(review)
//        experience = experience // TODO: Implement publishChanges method that does this line
//        do {
//            try await repository.updateExperience(experience: self.experience)
//        } catch {
//            print("Error adding review: \(error)")
//        }
//    }
//    
//    func removeReview(reviewId : String) async {
//        experience.reviews.removeAll { $0.id == reviewId }
//        experience = experience
//        do {
//            try await repository.updateExperience(experience: self.experience)
//        } catch {
//            print("Error removing review: \(error)")
//        }
//    }
//    
//    func addPhoto(url: String) async {
//        experience.photo_urls.append(url)
//        experience = experience
//        do {
//            try await repository.updateExperience(experience: self.experience)
//        } catch {
//            print("Error adding photo: \(error)")
//        }
//    }
//    
//    func removePhoto(url: String) async {
//        experience.photo_urls.removeAll { $0 == url }
//        experience = experience
//        do {
//            try await repository.updateExperience(experience: self.experience)
//        } catch {
//            print("Error removing photo: \(error)")
//        }
//    }
    
}

