//
//  ExperienceRepository.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//


import Foundation
import SwiftUICore
import Supabase

class ExperienceRepository {
    let client : SupabaseClient
    
    init(client : SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
    }
    
    func createExperience(experience : Experience) async throws {
        try await client
            .from("Experience")
            .insert(experience)
            .execute()
    }
    
    func fetchAllExperiences(for userID: String) async throws -> [Experience] {
        let experiences: [ExperienceParticipant] = try await client
            .from("Experience_Participant")
            .select()
            .eq("user_id", value: userID)
            .execute()
            .value
        
        let experienceIDs = experiences.map { $0.experienceID }
        
        if (experienceIDs.isEmpty) {
            return []
        }
        
        return try await client
            .from("Experience")
            .select()
            .in("experience_id", values: experienceIDs)
            .execute()
            .value
    }
    
    func updateExperience(experience : Experience) async throws {
        try await client
            .from("Experience")
            .upsert(experience)
            .eq("experience_id", value: experience.id)
            .execute()
    }
    
    func deleteExperience(experience : Experience) async throws {
        try await client
            .from("Experience")
            .delete()
            .eq("id", value: experience.id)
            .execute()
    }
    
    func fetchReviews(for experienceID : String) async throws -> [Review] {
        return try await client
            .from("Review")
            .select()
            .eq("experience_id", value: experienceID)
            .execute()
            .value
    }
    
    func fetchParticipants(for experienceID : String) async throws -> [Review] {
        let participants: [ExperienceParticipant] = try await client
            .from("Experience_Participant")
            .select()
            .eq("experience_id", value: experienceID)
            .execute()
            .value
        
        let userIDs = participants.map { $0.userID }
        
        if (userIDs.isEmpty) {
            return []
        }
        
        return try await client
            .from("User")
            .select()
            .in("id", values: userIDs)
            .execute()
            .value
    }
}
