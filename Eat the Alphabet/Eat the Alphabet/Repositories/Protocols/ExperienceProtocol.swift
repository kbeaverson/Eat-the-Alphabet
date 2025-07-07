//
//  ExperienceProtocol.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/30.
//

protocol ExperienceProtocol {
    // Basic CRUD operations
    func getExperience(by id: String) async throws -> Experience
    func getExperiences(byChallenge challengeId: String) async throws -> [Experience]
    func createExperience(challengeId: String, restaurantId: String, letter: String) async throws
    func createExperience(experience: Experience) async throws
    func updateExperience(experience: Experience) async throws
    // func getExperienceDetails(by id: String) async throws -> ExperienceDetails    func updateExperienceStatus(id: String, status: String) async throws
    func deleteExperience(id: String) async throws
    
    // func getExperienceDetails(by id: String) async throws -> ExperienceDetails
    
    // get with related data
    func getWithRestaurant(for experienceId: String) async throws -> Experience
    
    // pariticipants
    func getWithParticipants(for experienceId: String) async throws -> Experience
    func addParticipant(userId: String, to experienceId: String) async throws
    func removeParticipant(userId: String, from experienceId: String) async throws
    
    // reviews
    func getWithReviews(by experienceId: String) async throws -> Experience
    // func addReview(review: Review, for experienceId: String) async throws
    // func deleteReview(reviewId: String, for experienceId: String) async throws
}
