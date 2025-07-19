//
//  ChallengeViewModel.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//
import Foundation
import CoreLocation

@MainActor
class ChallengeViewModel : ObservableObject {
    @Published var challenge: Challenge
    
    private let challengeRepository : ChallengeRepository
    private let experienceRepository : ExperienceRepository
    private let accountRepository : AccountRepository
    
    init(
        challenge: Challenge,
    ) {
        self.challenge = challenge
        self.challengeRepository = ChallengeRepository()
        self.experienceRepository = ExperienceRepository()
        self.accountRepository = AccountRepository()
    }
    
    func createChallenge() async throws {
        try await challengeRepository.createChallenge(challenge: self.challenge)
    }
    
    func deleteChallenge() async throws {
        try await challengeRepository.deleteChallenge(id: self.challenge.id)
    }
    
    func updateChallengeTitle(newTitle : String) async throws {
        challenge.title = newTitle
        challenge = challenge
        try await challengeRepository.updateChallenge(challenge: self.challenge)
    }
    
    func updateChallengeCoords(newCoords : CLLocationCoordinate2D) async throws {
        // in format POINT(-73.946823 40.807416)
        challenge.center_wgs = String(format: "POINT(%.6f %.6f)", newCoords.longitude, newCoords.latitude)
        challenge = challenge
        try await challengeRepository.updateChallenge(challenge: self.challenge)
    }
    
    func updateChallengeRadius(newRadius : Float) async throws {
        challenge.radius = newRadius
        challenge = challenge
        try await challengeRepository.updateChallenge(challenge: self.challenge)
    }
    
    func getCLLCoordinates() async -> CLLocationCoordinate2D? {
        do {
            let location: CLLocationCoordinate2D = try await challengeRepository.getChallengeLocation(challengeId: challenge.id)
            print("Fetched challenge location: \(location.latitude), \(location.longitude)")
            return location
        } catch {
            print("Error fetching challenge location: \(error)")
            return nil
        }
    }
    
    func addChallengeExperience(experience : Experience) async throws{
        challenge.experiences = (challenge.experiences ?? []) + [experience]
        challenge = challenge
        try await challengeRepository.updateChallenge(challenge: self.challenge)
    }
    
    func removeChallengeExperience(experience : Experience) async throws {
        challenge.experiences = (challenge.experiences ?? []).filter { $0.id != experience.id }
        challenge = challenge
        try await challengeRepository.updateChallenge(challenge: self.challenge)
    }
    
    func addChallengeParticipant(participant : Account) async throws {
        challenge.participants = (challenge.participants ?? []) + [participant]
        challenge = challenge
        try await challengeRepository.updateChallenge(challenge: self.challenge)
    }
    
    func removeChallengeParticipant(participant : Account) async throws {
        challenge.participants = (challenge.participants ?? []).filter { $0.id != participant.id }
        challenge = challenge
        try await challengeRepository.updateChallenge(challenge: self.challenge)
    }
    
    func loadWithParticipants() async throws {
        let challengeWithParticipants = try await challengeRepository.fetchWithParticipants(byChallengeId: challenge.id)
        challenge.participants = challengeWithParticipants.participants
        challenge = challengeWithParticipants
    }
    
    func loadWithExperience() async throws{
        let challengeWithRepository = try await challengeRepository.fetchWithExperiences(byChallengeId: challenge.id)
        challenge.experiences = challengeWithRepository.experiences
        challenge = challengeWithRepository
    }
    
    func getIfParticipated(userId: String, challengeId: String) async throws -> Bool {
        return try await challengeRepository.checkParticipation(userId: userId, challengeId: challengeId)
    }
    
    func joinChallenge(userId: String, challengeId: String) async throws {
        try await challengeRepository.addParticipant(userId: userId, challengeId: challengeId)
        // After joining, reload participants to update the challenge state
        try await loadWithParticipants()
    }
    
    func leaveChallenge(userId: String, challengeId: String) async throws {
        try await challengeRepository.removeParticipant(userId: userId, challengeId: challengeId)
        // After leaving, reload participants to update the challenge state
        try await loadWithParticipants()
    }
}
