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

    // Participants
    func addParticipant(userId: String, to challengeId: String) async throws
    func removeParticipant(userId: String, from challengeId: String) async throws
    func getParticipants(byChallengeId challengeId: String) async throws -> [Account]
    

    // Experiences (progress tracking)
    func getExperiences(by challengeId: String) async throws -> [Experience]
//    func getCompletedExperiences(in challengeId: String) async throws -> [Experience]
//    func getExperience(forLetter letter: Character, in challengeId: String) async throws -> Experience?
    
    // Letters
    func getLetters(in challengeId: String) async throws -> [String]
    
    // Search and discovery
//    func searchChallenges(by keyword: String) async throws -> [Challenge]
//    func getNearbyChallenges(near point: GeoPoint, radius: Float) async throws -> [Challenge]

    // Optional analytics
}
