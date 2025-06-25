//
//  ChallengeRepository.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//

import Foundation
import CoreLocation
import Supabase

// TODO: Unwrap all of the async methods so that the do/catch can be implemented at the ViewModel layer so as to allow error message propagation to the User
class ChallengeRepository {
    let client : SupabaseClient
    
    init(client : SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
    }
    
    func createChallenge(challenge : Challenge) async {
        do {
            try await client
                .from("Challenge")
                .insert(challenge)
                .execute()
            print("Challenge successfully created.")
        } catch {
            print("Error creating challenge: \(error)")
        }
    }
    
    func fetchAllChallenges(for userID : String) async -> [Challenge] {
        do {
            let challenges: [ChallengeParticipant] = try await client
                .from("Challenge_Participant")
                .select()
                .eq("user_id", value: userID)
                .execute()
                .value
            
            let challengeIds = challenges.map{ $0.challengeID }
            
            if (challengeIds.isEmpty) {
                print("No challenges found for user \(userID).")
                return []
            }
            
            return try await client
                .from("Challenge")
                .select()
                .in("id", values: challengeIds)
                .execute()
                .value
        } catch {
            print("Error fetching challenges: \(error)")
            return []
        }
    }
    
    func updateChallenge(challenge : Challenge) async {
        do {
            try await client
                .from("Challenge")
                .upsert(challenge)
                .execute()
            print("Challenge successfully updated.")
        } catch {
            print("Error updating challenge: \(error)")
        }
        
    }
    
    func deleteChallenge(challenge : Challenge) async {
        do {
            try await client
                .from("Challenge")
                .delete()
                .eq("id", value: challenge.id)
                .execute()
            print("Challenge successfully deleted.")
        } catch {
            print("Error deleting challenge: \(error)")
        }
    }
    
    func fetchExperiences(for challengeID : String) async -> [Experience] {
        do {
            return try await client
                .from("Experience")
                .select()
                .eq("challenge_id", value: challengeID)
                .execute()
                .value
        } catch {
            print("Error fetching experiences: \(error)")
            return []
        }
    }
    
    func fetchParticipants(for challengeID : String) async -> [User] {
        do {
            let participants: [ChallengeParticipant] = try await client
                .from("Challenge_Participant")
                .select()
                .eq("challenge_id", value: challengeID)
                .execute()
                .value
            
            let userIDs = participants.map { $0.userID }
            
            if (userIDs.isEmpty) {
                print("No participants found for this challenge: \(challengeID)")
                return []
            }
            
            return try await client
                .from("User")
                .select()
                .in("id", values: userIDs)
                .execute()
                .value
        } catch {
            print("Error fetching participants: \(error)")
            return []
        }
    }
}
