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
            /**let reponseStatus =*/
             try await supabaseClient
                .from("Challenge")
                .insert(challenge)
                .execute()
        } catch {
            print("Error creating challenge: \(error)")
            throw error
        }
    }
    
    // 2 Read by its id
    func fetchChallenge(by id: String) async throws -> Challenge? {
        do {
            let challenges: [Challenge] = try await supabaseClient
                .from("ChallengeWithWKT")
                .select()
                .eq("id", value: id)
                .execute()
                .value
            
            guard let challenge = challenges.first else {
                throw NSError(domain: "ChallengeRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "Challenge not found with id \(id)"])
            }
            
            return challenge
        } catch {
            print("Error fetching challenge: \(error)")
            throw error
        }
    }
    
    // 2 Read by user id
    func fetchChallenges(byUser userId: String) async throws -> [Challenge] {
        do {
            let challengesOfUser: [Challenge] = try await accountRepository.fetchChallenges(for: userId) ?? []
            
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
            /**let responseStatus = */
            try await supabaseClient
                .from("Challenge")
                .update(challenge)
                .eq("id", value: challenge.id)
                .execute()
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
            throw error
        }
    }
    
    func searchChallenges(byIdPart: String) async throws -> [Challenge] {
        do {
            // get anything that contains the the input
            let challenges: [Challenge] = try await supabaseClient
                .from("ChallengeWithWKT")
                .select()
                // .ilike("id", pattern: "%\(byIdPart)%")
                .eq("id", value: byIdPart)
                .execute()
                .value
            
            return challenges
        } catch {
            print("Error searching challenges by ID part: \(error)")
            throw error
        }
    }
    
    func fetchWithExperiences(byChallengeId challengeId: String) async throws -> Challenge {
        do {
            // AWAITING DEBUG
            let challengeWithExperience : Challenge = try await supabaseClient
                .from("ChallengeWithWKT")
                .select(
                    """
                    *,
                    id,
                    Experience(challenge_id, *)
                    """
                )
                .eq("id", value: challengeId)
                .single()
                .execute()
                .value
                
            return challengeWithExperience
        } catch {
            print("Error fetching experiences: \(error)")
            throw error
        }
    }
    
    func fetchExperiences(byChallengeId challengeId: String) async throws -> [Experience] {
        do {
            let experiences: [Experience] = try await supabaseClient
                .from("Experience")
                .select()
                .eq("challenge_id", value: challengeId)
                .execute()
                .value
            
            return experiences
        } catch {
            print("Error fetching experiences: \(error)")
            throw error
        }
    }

    
    func fetchExperience(byLetter letter: Character, in challengeId: String) async throws -> Experience? {
        do {
            let experiences: [Experience] = try await supabaseClient
                .from("Experience")
                .select()
                .eq("challenge_id", value: challengeId)
                .eq("letter", value: String(letter).uppercased())
                // .single()
                .execute()
                .value
            
            // print("Fetched Experience: \(experiences)")
            
            // Return the first experience found for the letter, or nil if none found
            return experiences[0]
        } catch {
            print("Error fetching experience for letter \(letter): \(error)")
            throw error
        }
    }
    
    /** Original intention of this methods was to fetch with foreign keys,
     so that one query can fetch both the challenge itself and its related data.
     Name change to "get WITH"*/
    // REVISE
    func fetchWithParticipants(byChallengeId challengeId: String) async throws -> Challenge {
        do {
            let challengeWithParticipants: [Challenge] = try await supabaseClient
                .from("ChallengeWithWKT")
                .select(
                    """
                    *,
                    id,
                    Account(id, *)
                    """
                )
                .eq("id", value: challengeId)
                .execute()
                .value

            return challengeWithParticipants[0]
        } catch {
            print("Error fetching participants: \(error)")
            throw error
        }
    }
    
    func fetchParticipants(byChallengeId challengeId: String) async throws -> [Account]? {
        do {
            let challengeWithParticipants: [Challenge] = try await supabaseClient
                .from("Challenge")
                .select(
                    """
                    *,
                    id,
                    Account(id, *)
                    """
                )
                .eq("id", value: challengeId)
                .execute()
                .value
            
            return challengeWithParticipants[0].participants
        } catch {
            print("Error fetching participants: \(error)")
            throw error
        }
    }
    
    func addParticipant(userId: String, challengeId: String) async throws {
        do {
            let challengeParticipant = ChallengeParticipant(userID: userId, challengeID: challengeId)
            let responseStatus = try await supabaseClient
                .from("Challenge_Participant")
                .insert(challengeParticipant)
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
    
    func removeParticipant(userId: String, challengeId: String) async throws {
        do {
            let responseStatus = try await supabaseClient
                .from("Challenge_Participant")
                .delete()
                // .match(["user_id": userId, "challenge_id": challengeId])
                .eq("user_id", value: userId)
                .eq("challenge_id", value: challengeId)
                .execute()
                .status
            
            // print ("Response Status: \(responseStatus)")
            guard responseStatus == 200 else {
                throw NSError(domain: "ChallengeRepository", code: responseStatus, userInfo: [NSLocalizedDescriptionKey: "Failed to leave challenge. Status code: \(responseStatus)"])
            }
        } catch {
            print("Error leaving challenge: \(error)")
            throw error
        }
    }
    
    func checkParticipation(userId: String, challengeId: String) async throws -> Bool {
        do {
            let participant: [ChallengeParticipant] = try await supabaseClient
                .from("Challenge_Participant")
                .select()
                .eq("user_id", value: userId)
                .eq("challenge_id", value: challengeId)
                .execute()
                .value
            
            return !participant.isEmpty
        } catch {
            print("Error checking participation: \(error)")
            throw error
        }
    }
    
    
    func fetchExperienceLetters(in challengeId: String, status: String) async throws -> [String] {
        do {
            let challengeWithLetters: Challenge = try await supabaseClient
                .from("Challenge")
                .select(
                    """
                    *,
                    id,
                    Experience(challenge_id, *)
                    """
                )
                .eq("id", value: challengeId)
                .eq("Experience.status", value: "\(status)")
                .single()
                .execute()
                .value
            
            print("Fetched Challenge with Letters: \(challengeWithLetters)")

            let letters: [String] = challengeWithLetters.experiences?.compactMap { experience in
                experience.letter
            } ?? []
            return letters
        } catch {
            print("Error fetching letters: \(error)")
            throw error
        }
    }
    
    func getChallengeLocation(challengeId: String) async throws -> CLLocationCoordinate2D {
        do {
            let challenge: [Challenge] = try await supabaseClient
                .from("ChallengeWithWKT")
                .select("""
                    id,
                    title,
                    center_wgs,
                    radius,
                    created_at,
                    description
                """)
                .eq("id", value: challengeId)
                .execute()
                .value
            guard !challenge.isEmpty else {
                throw NSError(domain: "ChallengeRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "Challenge not found."])
            }
            guard let location = challenge[0].center_wgs else {
                throw NSError(domain: "ChallengeRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "Challenge location not found."])
            }
            // parse from String to CLLocationCoordinate2D: "POINT(121.469435 31.224894)" to CLLocationCoordinate2D(latitude: 31.224894, longitude: 121.469435)
            print("Challenge Location: \(location)")
            let coordinates = location.replacingOccurrences(of: "POINT(", with: "")
                .replacingOccurrences(of: ")", with: "")
                .split(separator: " ")
                .compactMap { Double($0) }
            guard coordinates.count == 2 else {
                throw NSError(domain: "ChallengeRepository", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid challenge location format."])
            }
            let latitude = coordinates[1]
            let longitude = coordinates[0]
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } catch {
            print("Error fetching challenge location: \(error)")
            throw error
        }
    }
}
