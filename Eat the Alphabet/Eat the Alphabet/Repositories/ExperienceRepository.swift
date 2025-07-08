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
    
    private let restaurantRepository: RestaurantRepository = RestaurantRepository()
    // 1 Read
    func getExperience(by id: String) async throws -> Experience {
        do {
            let experiences: Experience = try await supabaseClient
                .from("Experience")
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
    
    func getExperiences(byChallenge challengeId: String) async throws -> [Experience] {
        do {
            let experiences: [Experience] = try await supabaseClient
                .from("Experience")
                .select()
                .eq("challenge_id", value: challengeId)
                .execute()
                .value
            
            if experiences.isEmpty {
                print("No experiences found for challenge \(challengeId).")
            }
            return experiences
        }
        catch {
            print("Error fetching experiences by challenge: \(error)")
            throw error
            
        }
    }
    
    // 2 Create - add new experience
    func createExperience(experience: Experience) async throws {
        do {
            try await supabaseClient
                .from("experiences")
                .insert(experience)
                .execute()
        } catch {
            print("Error creating experience: \(error)")
            throw error
        }
    }
    
    func createExperience(challengeId: String, restaurantId: String, letter: String) async throws {
        let experience = Experience(
            id: UUID().uuidString,
            created_at: Date(),
            status: "incomplete",
            restaurant_id: restaurantId,
            challenge_id: challengeId,
            letter: letter
        )
        // NOTE: there is a letter as parameter so that creator can alter if auto detection did not work correctly
        do {
            try await createExperience(experience: experience)
        } catch {
            print("Error creating experience: \(error)")
            throw error
        }
    }
    
    // 3 Update - update an existing experience
    func updateExperience(experience: Experience) async throws {
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
    
    // 4 Delete - delete an experience by id
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
    
    // FIXED: under review
    func getRestaurant(for experienceId: String) async throws -> Restaurant {
        do {
            let restaurant: Restaurant = try await restaurantRepository.getRestaurant(by: experienceId)
            return restaurant
        } catch {
            print("Error fetching restaurant for experience: \(error)")
            throw error
        }
    }
    
    // FIXED
    func getWithParticipants(for experienceId: String) async throws -> Experience {
        do {
            let experienceWithParticipants: Experience = try await supabaseClient
                .from("Experience")
                .select(
                    """
                    *,
                    participants(*)
                    """)
                .eq("experience_id", value: experienceId)
                .single()
                .execute()
                .value
            return experienceWithParticipants
        } catch {
            print("Error fetching participants for experience: \(error)")
            throw error
        }
    }
    
    // CREATE FIXED: under review
    func addParticipant(userId: String, to experienceId: String) async throws {
        let experienceParticipant = ExperienceParticipant(
            // id: UUID().uuidString,
            userID: userId,
            experienceID: experienceId
            // created_at: Date()
        )
        
        do {
            try await supabaseClient
                .from("Experience_Participant")
                .insert(experienceParticipant)
                .execute()
        } catch {
            print("Error adding participant to experience: \(error)")
            throw error
        }
    }
    
    // REMOVE FIXED: Under review
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
    
    func getWithReviews(by experienceId : String) async throws -> Experience {
        do {
            return try await supabaseClient
                .from("Experience")
                .select(
                    """
                    *,
                    reviews(*)
                    """
                )
                .eq("id", value: experienceId)
                .single()
                .execute()
                .value as Experience
        }
        catch {
            print("Error fetching reviews: \(error)")
            throw error
        }
    }
    
    // NOTE: this is now under review repository
//    func addReview(review: Review, for experienceId: String) async throws -> Void{
//        
//    }
    
    func getSelfLetter(for experienceId: String) async throws -> String? {
        do {
            let experience: Experience = try await supabaseClient
                .from("experiences")
                .select("letter")
                .eq("id", value: experienceId)
                .single()
                .execute()
                .value
            
            return experience.letter
        } catch {
            print("Error fetching self letter for experience: \(error)")
            throw error
        }
    }
}
