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
        challenge.center_wgs = GeoPoint(newCoords)
        challenge = challenge
        try await challengeRepository.updateChallenge(challenge: self.challenge)
    }
    
    func updateChallengeRadius(newRadius : Float) async throws {
        challenge.radius = newRadius
        challenge = challenge
        try await challengeRepository.updateChallenge(challenge: self.challenge)
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
    
    func loadParticipants() async throws {
        let challengeWithParticipants = try await challengeRepository.getWithParticipants(byChallengeId: challenge.id)
        challenge.participants = challengeWithParticipants.participants
        challenge = challengeWithParticipants
    }
    
    func loadExperience() async throws{
        let challengeWithRepository = try await challengeRepository.getWithExperiences(by: challenge.id)
        challenge.experiences = challengeWithRepository.experiences
        challenge = challengeWithRepository
    }
}
