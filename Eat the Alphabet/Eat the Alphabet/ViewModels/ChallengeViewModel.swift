//
//  ChallengeViewModel.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//
import Foundation
import CoreLocation

class ChallengeViewModel : ObservableObject {
    @Published var challenge: Challenge
    private let repository : ChallengeRepository
    
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
        repository: ChallengeRepository = ChallengeRepository()
    ) {
        self.challenge = challenge
        self.repository = repository
    }
    
    func createChallenge() {
        // FIXME: Call create method from ChallengeRepository for this challenge
    }
    
    func deleteChallenge() {
        // FIXME: Call delete method from ChallengeRepository using this challenge
    }
    
    func updateChallengeTitle(newTitle : String) {
        challenge.title = newTitle
        challenge = challenge
        // FIXME: Call update method from ChallengeRepository
    }
    
    func updateChallengeCoords(newCoords : CLLocationCoordinate2D) {
        challenge.address = GeoPoint(newCoords)
        challenge = challenge
        // FIXME: Call update method from ChallengeRepository
    }
    
    func updateChallengeRadius(newRadius : Float) {
        challenge.radius = newRadius
        challenge = challenge
        // FIXME: Call update method from ChallengeRepository
    }
    
    func addChallengeExperience(experience : Experience) {
        challenge.experiences.append(experience)
        challenge = challenge
        // FIXME: Call update method from ChallengeRepository
    }
    
    func removeChallengeExperience(experience : Experience) {
        challenge.experiences.removeAll { $0.id == experience.id}
        challenge = challenge
        // FIXME: Call update method from ChallengeRepository
    }
    
    func addChallengeParticipant(participant : User) {
        challenge.participants.append(participant)
        challenge = challenge
        // FIXME: Call update method from ChallengeRepository
    }
    
    func removeChallengeParticipant(participant : User) {
        challenge.participants.removeAll { $0.id == participant.id }
        challenge = challenge
        // FIXME: Call update method from ChallengeRepository
    }
}
