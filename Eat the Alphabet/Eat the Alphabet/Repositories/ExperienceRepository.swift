//
//  ExperienceRepository.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//


import Foundation
import SwiftUICore
import Supabase

class ExperienceRepository : ExperienceProtocol {
    
    func getExperience(by id: String) async throws -> Experience {
        do {
            let experiences: Experience = try await supabaseClient
                .from("experiences")
                .select()
                .eq("id", value: id)
                .single()
                .execute()
                .value
            return experiences
        } catch {
            print("Error fetching experience: \(error)")
            throw error
        }
    }
    
    // Create - add new experience
    func createExperience(experience : Experience) async throws {
        do {
            try await supabaseClient
                .from("experiences")
                .insert(experience)
                .execute()
        } catch {
            throw error
        }
    }
    
    func createExperience(challengeId: String, restaurantId: String) async throws {
        let experience = Experience(
            id: UUID().uuidString,
            created_at: Date(),
            status: "incomplete",
            restaurant_id: restaurantId,
            challenge_id: challengeId)
        do {
            try await createExperience(experience: experience)
        } catch {
            print("Error creating experience: \(error)")
            throw error
        }
    }
    
    func updateExperience(experience : Experience) async throws {
        do {
            try await supabaseClient
                .from("Experience")
                .update(experience)
                .execute()
        }
        catch {
            print("Error updating experience: \(error)")
            throw error
        }
    }
    
    func deleteExperience(id : String) async throws {
        do {
            try await supabaseClient
                .from("Experience")
                .delete()
                .eq("id", value: id)
                .execute()
        }
        catch {
            print("Error deleting experience: \(error)")
            throw error
        }
    }
    
    
    
    // Read - fetch all experiences for a user, in async manner
    //    func getAllExperiences(for userID: String) async throws -> [Experience] {
    //        let experiences: [ExperienceParticipant] = try await supabaseClient
    //            .from("Experience_Participant")
    //            .select()
    //            .eq("user_id", value: userID)
    //            .execute()
    //            .value
    //
    //        let experienceIDs = experiences.map { $0.experienceID }
    //
    //        if (experienceIDs.isEmpty) {
    //            return []
    //        }
    //
    //        return try await supabaseClient
    //            .from("Experience")
    //            .select()
    //            .in("experience_id", values: experienceIDs)
    //            .execute()
    //            .value
    //    }
    
    // FIXME: placeholder
    func getRestaurant(for experienceId: String) async throws -> Restaurant {
        do {
            let restaurant: Restaurant = try await supabaseClient
                .from("Restaurant")
                .select()
                .eq("experience_id", value: experienceId)
                .single()
                .execute()
                .value
            return restaurant
        } catch {
            print("Error fetching restaurant for experience: \(error)")
            throw error
        }
    }
    
    // FIXME: placeholder
    func getParticipants(for experienceId: String) async throws -> [Account] {
        do {
            let participants: [Account] = try await supabaseClient
                .from("Experience_Participant")
                .select()
                .eq("experience_id", value: experienceId)
                .execute()
                .value
            
            return participants
        } catch {
            print("Error fetching participants for experience: \(error)")
            throw error
        }
    }
    
    // FIXME: placeholder
    func addParticipant(userId: String, to experienceId: String) async throws {
        let participant = ExperienceParticipant(
            // id: UUID().uuidString,
            userID: userId,
            experienceID: experienceId
            // created_at: Date()
        )
        
        do {
            try await supabaseClient
                .from("Experience_Participant")
                .insert(participant)
                .execute()
        } catch {
            print("Error adding participant to experience: \(error)")
            throw error
        }
        
    }
    
    // FIXME: placeholder
    func removeParticipant(userId: String, from experienceId: String) async throws {
        do {
            try await supabaseClient
                .from("Experience_Participant")
                .delete()
                .eq("user_id", value: userId)
                .eq("experience_id", value: experienceId)
                .execute()
        } catch {
            print("Error removing participant from experience: \(error)")
            throw error
        }
    }
    // static let shared = ExperienceRepository()
    
    func getReviews(for experienceId : String) async throws -> [Review] {
        do {
            return try await supabaseClient
                .from("Review")
                .select()
                .eq("experience_id", value: experienceId)
                .execute()
                .value
        }
        catch {
            print("Error fetching reviews: \(error)")
            throw error
            
        }
    }
    
    // add a Review to the Experience, if succeed (unlikely this step would fail), append the Review to the reviews array in the Experience object, update it to the database
    func addReview(review: Review, for experienceId: String) async throws -> Void{
        
    }
    // FIXME: placeholder
    func deleteReview(reviewId: String, for experienceId: String) async throws {
        do {
            try await supabaseClient
                .from("Review")
                .delete()
                .eq("id", value: reviewId)
                .eq("experience_id", value: experienceId)
                .execute()
        } catch {
            print("Error deleting review: \(error)")
            throw error
            
        }
    }
    
    enum PhotoUploadError: Error {
        case invalidImage
    }
}
