//
//  ExperienceProtocol.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/30.
//

protocol ExperienceProtocol {
    func createExperience(challengeId: String, restaurantId: String) async throws -> Experience
    func getExperienceDetails(by id: String) async throws -> ExperienceDetails
    func updateExperienceStatus(id: String, status: String) async throws
    func deleteExperience(id: String) async throws
    
    // lazy loading
    func getExperience(by id: String) async throws -> Experience
    func getParticipants(for experienceId: String) async throws -> [Account]
    func getReviews(for experienceId: String) async throws -> [Review]
    func getRestaurant(for experienceId: String) async throws -> Restaurant
    
    
    // pariticipants
    func getParticipants(for experienceId: String) async throws -> [Account]
    func addParticipant(userId: String, to experienceId: String) async throws
    func removeParticipant(userId: String, from experienceId: String) async throws
    
    // reviews
    func getReviews(for experienceId: String) async throws -> [Review]
    func addReview(_ review: Review, for experienceId: String) async throws
    func deleteReview(_ reviewId: String, for experienceId: String) async throws
}
