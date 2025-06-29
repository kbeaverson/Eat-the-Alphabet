//
//  ChallengeProtocol.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/30.
//

protocol ChallengeProtocol {
    // Basic CRUD
    func createChallenge(_ challenge: Challenge, createdBy userId: String) async throws -> Challenge
    func getChallenge(by id: String) async throws -> Challenge
    func updateChallenge(_ challenge: Challenge) async throws
    func deleteChallenge(id: String) async throws

    // Participants
    func addParticipant(userId: String, to challengeId: String) async throws
    func removeParticipant(userId: String, from challengeId: String) async throws
    func getParticipants(of challengeId: String) async throws -> [Account]
    func getChallenges(for userId: String) async throws -> [Challenge]

    // Experiences (progress tracking)
    func getExperiences(in challengeId: String) async throws -> [Experience]
    func getCompletedExperiences(in challengeId: String) async throws -> [Experience]
    func getExperience(forLetter letter: Character, in challengeId: String) async throws -> Experience?

    // Search and discovery
    func searchChallenges(by keyword: String) async throws -> [Challenge]
    func getNearbyChallenges(near point: GeoPoint, radius: Float) async throws -> [Challenge]

    // Optional analytics
    func getChallengeProgress(challengeId: String) async throws -> ChallengeProgressSummary
}
