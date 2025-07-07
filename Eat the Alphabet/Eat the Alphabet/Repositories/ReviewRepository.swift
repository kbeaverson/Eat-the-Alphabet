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
    func createReview(review : Review) async throws {
        do {
            try await supabaseClient
                .from("Review")
                .insert(review)
                .execute()
                .value
        }
        catch {
            print("Error creating review: \(error)")
            throw error
        }

    }
    
    // 2
    func getReview(by id: String) async throws -> Review {
        do {
            return try await supabaseClient
                .from("Review")
                .select()
                .eq("id", value: id)
                .execute()
                .value
        } catch {
            print("Error fetching review: \(error)")
            
            throw error
        }

    }
    
    // 3 can update only if user id matches
    func updateReview(review: Review, userId: String) async throws -> Review {
        do {
            return try await supabaseClient
                .from("Review")
                .update(review)
                .eq("id", value: review.id)
                .eq("user_id", value: userId)
                .execute()
                .value
        } catch {
            print("Error updating review: \(error)")
            throw error
        }
    }
    
    // 4
    func deleteReview(by id: String) async throws {
        try await supabaseClient
            .from("Review")
            .delete()
            .eq("id", value: id)
            .execute()
    }
    

    
}
