//
//  ReviewRepository.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//

import Foundation
import Supabase

final class ReviewRepository : ReviewProtocol {
    private let experienceRepository: ExperienceProtocol = ExperienceRepository()
    
    func fetchReviews(byUser userId: String) async throws -> [Review] {
        do {
            let reviews: [Review] = try await supabaseClient
                .from("Review")
                .select()
                .eq("user_id", value: userId)
                .execute()
                .value
            
            if reviews.isEmpty {
                print("No reviews found for user \(userId).")
            }
            return reviews
        } catch {
            print("Error fetching reviews by user: \(error)")
            throw error
        }
    }
    
    func fetchReviews(byExperience experienceId: String) async throws -> [Review] {
        do {
            let reviews: [Review] = try await supabaseClient
                .from("Review")
                .select()
                .eq("experience_id", value: experienceId)
                .execute()
                .value
            
            if reviews.isEmpty {
                print("No reviews found for experience \(experienceId).")
            }
            return reviews
        } catch {
            print("Error fetching reviews by experience: \(error)")
            throw error
        }
    }
    
    func fetchReviews(byRestaurant restaurantId: String) async throws -> [Review] {
        do {
            // get experiences associated with the restaurant
            let experiences: [Experience] = try await experienceRepository.fetchExperiences(byRestaurant: restaurantId)
            if experiences.isEmpty {
                print("No experiences found for restaurant \(restaurantId).")
                return []
            }
            // get reviews associated with those experiences
            let experienceIds = experiences.map { $0.id }
            let reviews: [Review] = try await supabaseClient
                .from("Review")
                .select()
                .in("experience_id", values: experienceIds)
                .execute()
                .value
            
            if reviews.isEmpty {
                print("No reviews found for restaurant \(restaurantId).")
                return []
            }
            return reviews
        } catch {
            print("Error fetching reviews by restaurant: \(error)")
            throw error
        }
    }
                
    
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
    func fetchReview(by id: String) async throws -> Review? {
        do {
            let review: [Review] = try await supabaseClient
                .from("Review")
                .select()
                .eq("id", value: id)
                .execute()
                .value
            if review.isEmpty {
                return nil
            }
            return review.first
        } catch {
            print("Error fetching review: \(error)")
            
            throw error
        }

    }
    
    // 3 can update only if user id matches
    func updateReview(review: Review, userId: String) async throws -> Void {
        do {
            try await supabaseClient
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
