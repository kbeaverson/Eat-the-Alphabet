//
//  ChallengeProtocol.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/30.
//

protocol ChallengeProtocol {
    // Basic CRUD
    func createChallenge(challenge: Challenge) async throws
    func getChallenge(by id: String) async throws -> Challenge
    func getChallenges(byUserId userId: String) async throws -> [Challenge]
    func updateChallenge(challenge: Challenge) async throws
    func deleteChallenge(id: String) async throws

    // Experiences (progress tracking)
    func getWithExperiences(by challengeId: String) async throws -> Challenge
    func getExperience(forLetter letter: Character, in challengeId: String) async throws -> Experience?
    
    // with Participants
    func getWithParticipants(byChallengeId challengeId: String) async throws -> Challenge
    
    // Letters
    func getLetters(in challengeId: String) async throws -> [String]
    
    // Search and discovery
//    func searchChallenges(by keyword: String) async throws -> [Challenge]
//    func getNearbyChallenges(near point: GeoPoint, radius: Float) async throws -> [Challenge]

    // Optional analytics
}
