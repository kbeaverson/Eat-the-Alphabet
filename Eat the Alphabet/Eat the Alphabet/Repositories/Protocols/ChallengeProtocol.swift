//
//  ChallengeProtocol.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/30.
//
import CoreLocation

protocol ChallengeProtocol {
    // Basic CRUD
    func createChallenge(challenge: Challenge) async throws
    func fetchChallenge(by id: String) async throws -> Challenge
    func updateChallenge(challenge: Challenge) async throws
    func deleteChallenge(id: String) async throws
    
    // Advanced R
    func fetchChallenges(byUser userId: String) async throws -> [Challenge]

    // Experience: get with child experiences; get only the child experiences
    func fetchWithExperiences(byChallengeId challengeId: String) async throws -> Challenge
    func fetchExperiences(byChallengeId challengeId: String) async throws -> [Experience]
    func fetchExperience(byLetter letter: Character, in challengeId: String) async throws -> Experience?
    
    // Participants
    // get with child Participants
    func fetchWithParticipants(byChallengeId challengeId: String) async throws -> Challenge
    func fetchParticipants(byChallengeId challengeId: String) async throws -> [Account]?
    // participants operation
    func checkParticipation(userId: String, challengeId: String) async throws -> Bool
    func addParticipant(userId: String, challengeId: String) async throws
    func removeParticipant(userId: String, challengeId: String) async throws
    
    // Letters
    func fetchExperienceLetters(in challengeId: String, status: String) async throws -> [String]
    
    // LOCATION: "POINT(** ***)" parse to CLLocationCoordinate2D
    func getChallengeLocation(challengeId: String) async throws -> CLLocationCoordinate2D
    
    // get with child Letters (NOTE: Child Experiences already included this information)
    // func fetchWithLetters(byChallengeId challengeId: String) async throws -> Challenge
    
    // Search and discovery
//    func searchChallenges(by keyword: String) async throws -> [Challenge]
//    func getNearbyChallenges(near point: GeoPoint, radius: Float) async throws -> [Challenge]

    // Optional analytics
}
