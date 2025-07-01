//
//  ReviewRepository.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//

import Foundation
import Supabase

final class ReviewRepository : ReviewProtocol {
    // 1
    func createReview(review : Review) async throws -> Review {
        try await supabaseClient
            .from("Review")
            .insert(review)
            .execute()
            .value
    }
    
    // 2
    func getReview(by id: String) async throws -> Review {
        try await supabaseClient
            .from("Review")
            .select()
            .eq("id", value: id)
            .execute()
            .value
    }
    
    // 3
    func updateReview(review: Review) async throws {
        try await supabaseClient
            .from("Review")
            .upsert(review)
            .execute()
    }
    
    // 4
    func deleteReview(by id: String) async throws {
        try await supabaseClient
            .from("Review")
            .delete()
            .eq("id", value: id)
            .execute()
    }
    
//    func getReviews(byUser userID: String) async throws -> [Review] {
//        // TODO: use Account's Repo function to do this
//    }
//    
//    func getReviews(byExperience experienceId: String) async throws -> [Review] {
//        // TODO: use Experience's Repo function to get an experience's reviews
//    }
//    func getReviews(byRestaurant restaurantId: String) async throws -> [Review] {
//        // TODO: use Restaurant's Repo function to get a restaurant's reviews
//    }
//    
//    func getAverageRating(forRestaurantId restaurantId: String) async throws -> Float? {
//        // TODO: use Restaurant's Repo function to get a rest's reviews, and calculate
//    }
    
    //    func getRecentReviews(limit: Int) async throws -> [Review] {
    //        <#code#>
    //    }
    //
    //    func hasUserReviewed(experienceId: String, userId: String) async throws -> Bool {
    //        <#code#>
    //    }

    
}
