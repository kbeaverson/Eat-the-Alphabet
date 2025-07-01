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
class ChallengeRepository : ChallengeProtocol {
    
    private let accountRepository: AccountRepository = AccountRepository()
    
    func createChallenge(challenge : Challenge) async throws -> Void {
        do {
            try await supabaseClient
                .from("Challenge")
                .insert(challenge)
                .execute()
            print("Challenge successfully created.")
        } catch {
            print("Error creating challenge: \(error)")
            throw error
        }
    }
    
    func getChallenge(by id: String) async throws -> Challenge {
        do {
            let challenge: Challenge = try await supabaseClient
                .from("Challenge")
                .select()
                .eq("id", value: id)
                .single()
                .execute()
                .value
            
            return challenge
        } catch {
            print("Error fetching challenge: \(error)")
            throw error
        }
    }
    
    func getChallenges(byUserId userId: String) async throws -> [Challenge] {
        // TODO: Implement fetching challenges by user ID
        do {
            let challengesOfUser: [Challenge] = try await accountRepository.getChallenges(for: userId)
            
            if challengesOfUser.isEmpty {
                print("No challenges found for user \(userId).")
                return []
            }
            
            return challengesOfUser
        } catch {
            print("Error fetching challenges by user ID: \(error)")
            throw error
        }
    }
    
    //    func fetchAllChallenges(for userID : String) async -> [Challenge] {
    //        do {
    //            let challenges: [ChallengeParticipant] = try await client
    //                .from("Challenge_Participant")
    //                .select()
    //                .eq("user_id", value: userID)
    //                .execute()
    //                .value
    //
    //            let challengeIds = challenges.map{ $0.challengeID }
    //
    //            if (challengeIds.isEmpty) {
    //                print("No challenges found for user \(userID).")
    //                return []
    //            }
    //
    //            return try await client
    //                .from("Challenge")
    //                .select()
    //                .in("id", values: challengeIds)
    //                .execute()
    //                .value
    //        } catch {
    //            print("Error fetching challenges: \(error)")
    //            return []
    //        }
    //    }
    
    func updateChallenge(challenge : Challenge) async throws -> Void {
        do {
            try await supabaseClient
                .from("Challenge")
                .upsert(challenge)
                .execute()
            print("Challenge successfully updated.")
        } catch {
            print("Error updating challenge: \(error)")
        }
        
    }
    
    func deleteChallenge(id: String) async throws -> Void {
        do {
            try await supabaseClient
                .from("Challenge")
                .delete()
                .eq("id", value: id)
                .execute()
            print("Challenge successfully deleted.")
        } catch {
            print("Error deleting challenge: \(error)")
        }
    }
    
    func getExperiences(by challengeId: String) async throws -> [Experience] {
        do {
            let challengeWithExperiences: Challenge = try await supabaseClient
                .from("Experience")
                .select(
                    """
                    *,
                    experiences(*)
                    """
                ) // FIXME: all of itself and all of the multi-to-multi participants
                .eq("challenge_id", value: challengeId)
                .single()
                .execute()
                .value
            return challengeWithExperiences.experiences ?? []
        } catch {
            print("Error fetching experiences: \(error)")
            throw error
        }
    }
    
    //    func fetchParticipants(for challengeID : String) async -> [User] {
    //        do {
    //            let participants: [ChallengeParticipant] = try await client
    //                .from("Challenge_Participant")
    //                .select()
    //                .eq("challenge_id", value: challengeID)
    //                .execute()
    //                .value
    //
    //            let userIDs = participants.map { $0.userID }
    //
    //            if (userIDs.isEmpty) {
    //                print("No participants found for this challenge: \(challengeID)")
    //                return []
    //            }
    //
    //            return try await client
    //                .from("User")
    //                .select()
    //                .in("id", values: userIDs)
    //                .execute()
    //                .value
    //        } catch {
    //            print("Error fetching participants: \(error)")
    //            return []
    //        }
    //    }
    func addParticipant(userId: String, to challengeId: String) async throws -> Void {
        // TODO: use participant (Account) methods for this
    }
    func removeParticipant(userId: String, from challengeId: String) async throws -> Void {
        // TODO: use participant (Account) methods for this
    }
    func getParticipants(byChallengeId challengeId: String) async throws -> [Account] {
        do {
            let challengeWithParticipants: Challenge = try await supabaseClient
                .from("Challenge")
                .select(
                    """
                    *,
                    participants(*)
                    """
                )
                .eq("id", value: challengeId)
                .single()
                .execute()
                .value
            
            return challengeWithParticipants.participants ?? []
        } catch {
            print("Error fetching participants: \(error)")
            throw error
        }
    }
    
    func getLetters(in challengeId: String) async throws -> [String] {
        do {
            let challengeWithLetters: Challenge = try await supabaseClient
                .from("Challenge")
                .select(
                    """
                    *,
                    letters(*)
                    """
                )
                .eq("id", value: challengeId)
                .single()
                .execute()
                .value
            
            return challengeWithLetters.letters ?? []
        } catch {
            print("Error fetching letters: \(error)")
            throw error
        }
    }
}
