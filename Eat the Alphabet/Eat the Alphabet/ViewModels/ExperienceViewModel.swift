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
    
    init(experience: Experience) {
        self.experience = experience
        self.repository = ExperienceRepository()
        self.accountRepository = AccountRepository()
        self.reviewRepository = ReviewRepository()
    }
    // FIXME
    
    // fetch experience by challenge_id

    
    func deleteExperience() async {
        // if experience is nil, it is not assigned and we warn-and-return
        guard let experience = experience else {
            print("Experience is nil, cannot delete.")
            return
        }
        do {
            try await repository.deleteExperience(id: experience.id)
        } catch {
            print("Error deleting experience: \(error)")
        }
    }
 
    func removeReview(reviewId : String) async {
        do {
            try await reviewRepository.deleteReview(by: reviewId)
        } catch {
            print("Error removing review: \(error)")
        }
    }

    func addPhoto() async throws {
        // TODO: get a photo passed in
        // TODO: handle EOF file
        // TODO: upload to bucket
        // TODO: handle upload error
        // TODO: get upload response (attempt to get a retrievable URL)
        // TODO: add URL to experience.photo_urls
        // TODO: update experience in repository
    }

    func deletePhoto(by experienceId: String) async {
        // TODO: set nil or empty string for photo_urls
        // TODO: update experience in repository
        // TODO: handle errors
        // TODO: delete photo from bucket
        // TODO: handle bucket deletion errors
    }
    
    func loadAssociatedRestaurant() async {
        guard let experience = experience else {
            print("Experience is nil, cannot load associated restaurant.")
            return
        }
        do {
            let restaurant: Restaurant? = try await repository.fetchRestaurant(for: experience.id)
            if let restaurant = restaurant {
                print("Loaded restaurant for experience \(experience.id): \(restaurant.name)")
                await MainActor.run {
                    // 这里建议直接赋值 experience（如果 experience 是 class，可以直接改属性）
                    self.experience?.restaurant = restaurant
                }
            } else {
                print("No restaurant found for experience \(experience.id)")
            }
        } catch {
            print("Error fetching restaurant for experience: \(error)")
        }
    }
    
    public func checkParticipation(experienceId: String) async throws -> Bool {
        guard let userId = supabaseClient.auth.currentUser?.id.uuidString.lowercased() else {
            print("No current user logged in.")
            return false
        }
        do {
            let isParticipating = try await repository.checkParticipation(userId: userId, experienceId: experienceId)
            return isParticipating
        } catch {
            print("Error checking participation: \(error)")
            throw error
        }
    }
        
    public func joinExperience(experienceId: String) async throws {
        do {
            // check participation first
            let isParticipating = try await repository.checkParticipation(userId: supabaseClient.auth.currentUser?.id.uuidString.lowercased() ?? "", experienceId: experienceId)
            if isParticipating {
                print("Already participating in experience \(experienceId)")
                return
            }
            // Join the experience
            try await repository.addParticipant(userId: supabaseClient.auth.currentUser?.id.uuidString.lowercased() ?? "", to: experienceId)
            print("Successfully joined experience \(experienceId)")
        } catch {
            print("Error joining experience: \(error)")
            throw error
        }
    }
    
    public func leaveExperience(experienceId: String) async throws {
        do {
            let isParticipating = try await repository.checkParticipation(userId: supabaseClient.auth.currentUser?.id.uuidString.lowercased() ?? "", experienceId: experienceId)
            if !isParticipating {
                print("Not participating in experience \(experienceId)")
                return
            }
            // Leave the experience
            try await repository.removeParticipant(userId: supabaseClient.auth.currentUser?.id.uuidString.lowercased() ?? "", from: experienceId)
            print("Successfully left experience \(experienceId)")
        } catch {
            print("Error leaving experience: \(error)")
            throw error
        }
    }

}

