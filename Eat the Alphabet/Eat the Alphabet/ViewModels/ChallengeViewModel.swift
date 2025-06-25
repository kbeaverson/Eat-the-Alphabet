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
    private let userRepository : UserRepository
    
    init(
        challenge: Challenge = Challenge(
            id: UUID().uuidString,
            title: "Sample Challenge",
            address: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            radius: 25.0,
            createDate: Date(),
            participants: [], // FIXME: Populate with current User
            experiences: []
        ),
        challengeRepository: ChallengeRepository = ChallengeRepository(),
        experienceRepository : ExperienceRepository = ExperienceRepository(),
        userRepository : UserRepository = UserRepository()
    ) {
        self.challenge = challenge
        self.challengeRepository = challengeRepository
        self.experienceRepository = experienceRepository
        self.userRepository = userRepository
    }
    
    func createChallenge() async {
        await challengeRepository.createChallenge(challenge: self.challenge)
    }
    
    func deleteChallenge() async {
        await challengeRepository.deleteChallenge(challenge: self.challenge)
    }
    
    func updateChallengeTitle(newTitle : String) async {
        challenge.title = newTitle
        challenge = challenge
        await challengeRepository.updateChallenge(challenge: self.challenge)
    }
    
    func updateChallengeCoords(newCoords : CLLocationCoordinate2D) async {
        challenge.address = GeoPoint(newCoords)
        challenge = challenge
        await challengeRepository.updateChallenge(challenge: self.challenge)
    }
    
    func updateChallengeRadius(newRadius : Float) async {
        challenge.radius = newRadius
        challenge = challenge
        await challengeRepository.updateChallenge(challenge: self.challenge)
    }
    
    func addChallengeExperience(experience : Experience) async {
        challenge.experiences.append(experience)
        challenge = challenge
        await challengeRepository.updateChallenge(challenge: self.challenge)
    }
    
    func removeChallengeExperience(experience : Experience) async {
        challenge.experiences.removeAll { $0.id == experience.id}
        challenge = challenge
        await challengeRepository.updateChallenge(challenge: self.challenge)
    }
    
    func addChallengeParticipant(participant : User) async {
        challenge.participants.append(participant)
        challenge = challenge
        await challengeRepository.updateChallenge(challenge: self.challenge)
    }
    
    func removeChallengeParticipant(participant : User) async {
        challenge.participants.removeAll { $0.id == participant.id }
        challenge = challenge
        await challengeRepository.updateChallenge(challenge: self.challenge)
    }
    
    func loadParticipants() async {
        let participants = await challengeRepository.fetchParticipants(for: challenge.id)
        challenge.participants = participants
        challenge = challenge
    }
    
    func loadExperiences() async {
        let experiences = await challengeRepository.fetchExperiences(for: challenge.id)
        challenge.experiences = experiences
        challenge = challenge
    }
}
