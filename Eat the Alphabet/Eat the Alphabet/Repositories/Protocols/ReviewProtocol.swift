//
//  ReviewProtocol.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/30.
//

protocol ReviewProtocol {
    // Basic CRUD
    // we do not use `_` to omit the parameter label
    func createReview(review: Review) async throws
    func getReview(by id: String) async throws -> Review
    func updateReview(review: Review, userId: String) async throws -> Review
    func deleteReview(by id: String) async throws

    // Relation-based queries (ordered by createdAt)
//    func getReviews(byUser userId: String) async throws -> [Review]
//    func getReviews(byExperience experienceId: String) async throws -> [Review]
//    func getReviews(byRestaurant restaurantId: String) async throws -> [Review]
//
//    // Aggregates
//    func getAverageRating(forRestaurantId restaurantId: String) async throws -> Float?
    // func getRecentReviews(limit: Int) async throws -> [Review]

    // Validation
    // func hasUserReviewed(experienceId: String, userId: String) async throws -> Bool
}
