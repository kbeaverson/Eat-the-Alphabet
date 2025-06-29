//
//  ReviewProtocol.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/30.
//

protocol ReviewProtocol {
    // Basic CRUD
    func createReview(_ review: Review) async throws -> Review
    func getReview(by id: String) async throws -> Review
    func updateReview(_ review: Review) async throws
    func deleteReview(id: String) async throws

    // Relation-based queries
    func getReviews(by userId: String) async throws -> [Review]
    func getReviews(for experienceId: String) async throws -> [Review]
    func getReviews(forRestaurantId restaurantId: String) async throws -> [Review]

    // Aggregates
    func getAverageRating(forRestaurantId restaurantId: String) async throws -> Float?
    func getRecentReviews(limit: Int) async throws -> [Review]

    // Validation
    func hasUserReviewed(experienceId: String, userId: String) async throws -> Bool
}
