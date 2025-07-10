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
    
    // 1 Create
    func createChallenge(challenge : Challenge) async throws -> Void {
        do {
            let reponseStatus = try await supabaseClient
                .from("Challenge")
                .insert(challenge)
                .execute()
                .status
            guard reponseStatus == 201 else {
                throw NSError(domain: "ChallengeRepository", code: reponseStatus, userInfo: [NSLocalizedDescriptionKey: "Failed to create challenge. Status code: \(reponseStatus)"])
            }
        } catch {
            print("Error creating challenge: \(error)")
            throw error
        }
    }
    
    // 2 Read by its id
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
    
    // 2 Read by user id
    func getChallenges(byUserId userId: String) async throws -> [Challenge] {
        do {
            let challengesOfUser: [Challenge] = try await accountRepository.getChallenges(for: userId)
            
            // print("Challenges found for user \(userId): \(challengesOfUser.count)")
            
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
    
    // 3 Update
    func updateChallenge(challenge : Challenge) async throws -> Void {
        do {
            let responseStatus = try await supabaseClient
                .from("Challenge")
                .upsert(challenge)
                .execute()
                .status
            guard responseStatus == 204 else {
                throw NSError(domain: "ChallengeRepository", code: responseStatus, userInfo: [NSLocalizedDescriptionKey: "Failed to update challenge. Status code: \(responseStatus)"])
            }
        } catch {
            print("Error updating challenge: \(error)")
            throw error
        }
        
    }
    
    // 4 Delete
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
    
    
    // REVISE: related items via forign table relationships
    func getWithExperiences(by challengeId: String) async throws -> Challenge {
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
            return challengeWithExperiences
        } catch {
            print("Error fetching experiences: \(error)")
            throw error
        }
    }
    
    func getExperience(forLetter letter: Character, in challengeId: String) async throws -> Experience? {
        do {
            let experiences: [Experience] = try await supabaseClient
                .from("Experience")
                .select()
                .eq("challenge_id", value: challengeId)
                .eq("letter", value: String(letter))
                .execute()
                .value
            
            // Return the first experience found for the letter, or nil if none found
            return experiences.first
        } catch {
            print("Error fetching experience for letter \(letter): \(error)")
            throw error
        }
    }
    

    
    /** Original intention of this methods was to fetch with foreign keys,
     so that one query can fetch both the challenge itself and its related data.
     Name change to "get WITH"*/
    // REVISE
    func getWithParticipants(byChallengeId challengeId: String) async throws -> Challenge {
        do {
            let challengeWithParticipants: Challenge = try await supabaseClient
                .from("Challenge_Participant")
                .select()
                .eq("id", value: challengeId)
                .single()
                .execute()
                .value
            return challengeWithParticipants
        } catch {
            print("Error fetching participants: \(error)")
            throw error
        }
    }
    
    func joinChallenge(userId: String, challengeId: String) async throws {
        do {
            let participant = ChallengeParticipant(userID: userId, challengeID: challengeId)
            let responseStatus = try await supabaseClient
                .from("Challenge_Participant")
                .insert(participant)
                .execute()
                .status
            
            guard responseStatus == 201 else {
                throw NSError(domain: "ChallengeRepository", code: responseStatus, userInfo: [NSLocalizedDescriptionKey: "Failed to join challenge. Status code: \(responseStatus)"])
            }
        } catch {
            print("Error joining challenge: \(error)")
            throw error
        }
    }
    
    func leaveChallenge(userId: String, challengeId: String) async throws {
        do {
            let responseStatus = try await supabaseClient
                .from("Challenge_Participant")
                .delete()
                .eq("user_id", value: userId)
                .eq("challenge_id", value: challengeId)
                .execute()
                .status
            
            guard responseStatus == 204 else {
                throw NSError(domain: "ChallengeRepository", code: responseStatus, userInfo: [NSLocalizedDescriptionKey: "Failed to leave challenge. Status code: \(responseStatus)"])
            }
        } catch {
            print("Error leaving challenge: \(error)")
            throw error
        }
    }
    
    func getIfParticipated(userId: String, challengeId: String) async throws -> Bool {
        do {
            let participant: ChallengeParticipant? = try await supabaseClient
                .from("Challenge_Participant")
                .select()
                .eq("user_id", value: userId)
                .eq("challenge_id", value: challengeId)
                .single()
                .execute()
                .value
            
            return participant != nil
        } catch {
            print("Error checking participation: \(error)")
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
}
