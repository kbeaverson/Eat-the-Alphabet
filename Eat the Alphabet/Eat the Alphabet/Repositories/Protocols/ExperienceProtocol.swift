//
//  ExperienceProtocol.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/30.
//

protocol ExperienceProtocol {
    // Basic CRUD operations
    func getExperience(by id: String) async throws -> Experience
    func createExperience(challengeId: String, restaurantId: String) async throws
    func createExperience(experience: Experience) async throws
    func updateExperience(experience: Experience) async throws
    // func getExperienceDetails(by id: String) async throws -> ExperienceDetails    func updateExperienceStatus(id: String, status: String) async throws
    func deleteExperience(id: String) async throws
    
    // func getExperienceDetails(by id: String) async throws -> ExperienceDetails
    
    // lazy loading
    func getRestaurant(for experienceId: String) async throws -> Restaurant
    
    // pariticipants
    func getParticipants(for experienceId: String) async throws -> [Account]
    func addParticipant(userId: String, to experienceId: String) async throws
    func removeParticipant(userId: String, from experienceId: String) async throws
    
    // reviews
    func getReviews(for experienceId: String) async throws -> [Review]
    func addReview(review: Review, for experienceId: String) async throws
    func deleteReview(reviewId: String, for experienceId: String) async throws
}
