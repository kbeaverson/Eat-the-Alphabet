//
//  ReviewRepository.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//

import Foundation
import Supabase

class ReviewRepository {
    let client : SupabaseClient
    
    init(client : SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
    }
    
    func createReview(review : Review) async throws {
        try await client
            .from("Review")
            .insert(review)
            .execute()
    }
    
    func deleteReview(review : Review) async throws {
        try await client
            .from("Review")
            .delete()
            .eq("id", value: review.id)
            .execute()
    }
    
    func fetchAllReviewsForUser(for userID: String) async throws -> [Review] {
        try await client
            .from("Review")
            .select()
            .eq("user_id", value: userID)
            .order("createdAt", ascending: false)
            .execute()
            .value
    }
    
    func fetchAllReviewsForExperience(for experienceID: String) async throws -> [Review] {
        try await client
            .from("Review")
            .select()
            .eq("experience_id", value: experienceID)
            .order("createdAt", ascending: false)
            .execute()
            .value
    }
    
    func updateReview(review: Review) async throws {
        try await client
            .from("Review")
            .upsert(review)
            .execute()
    }
}
