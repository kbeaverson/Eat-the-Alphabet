//
//  ChallengeViewModel.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//
import Foundation
import CoreLocation

extension ChallengeListView {
    class ViewModel : Observable {
        @Published var challenges: [Challenge] = [
            Challenge(
                id: "1",
                title: "Sample Challenge",
                address: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                radius: 5.0,
                createDate: Date(),
                restaurants: [], // replace with mock data if available
                participants: [], // replace with mock data if available
                experiences: [], // replace with mock data if available
                // remainingLetters: ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
            )
        ]
        private var repository : ChallengeRepository
        
        init(challenges: [Challenge] = [], repository : ChallengeRepository = ChallengeRepository()) {
            self.challenges = challenges
            self.repository = repository
        }
        
        // Load all challenges from the repository
        func loadChallenges() {
            // FIXME: Call fetchAll method from ChallengeRepository
        }
        
        func createChallenge(id : String, title : String, address : CLLocationCoordinate2D) {
            var challenge = Challenge(
                id: id,
                title: title,
                address: GeoPoint(address),
                radius: 25.0, // FIXME: Decide default radius size
                createDate: Date(),
                restaurants: [], 
                participants: [], 
                experiences: [], 
                // remainingLetters: ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
            )
            challenges.append(challenge)
        }
        
        func deleteChallenge(challenge : Challenge) {
            // FIXME: Call delete method from ChallengeRepository
        }
        
        func updateChallengeTitle(challenge : inout Challenge, newTitle : String){
            challenge.title = newTitle
        }
        
        func updateChallengeCoords(challenge : inout Challenge, newCoords : CLLocationCoordinate2D) {
            var newGeo : GeoPoint = GeoPoint(newCoords)
            challenge.address = newGeo
            // FIXME: Call update method from ChallengeRepository
        }
        
        func updateChallengeRadius(challenge : inout Challenge, newRadius : Float) {
            challenge.radius = newRadius
            // FIXME: Call update method from ChallengeRepository
        }
        
        func addChallengeExperience(challenge : inout Challenge, experience : Experience) {
            challenge.experiences.append(experience)
            // FIXME: Call update method from ChallengeRepository
        }
        
        func removeChallengeExperience(challenge: inout Challenge, experience : Experience) {
            challenge.experiences.removeAll { $0.id == experience.id }
            // FIXME: Call update method from ChallengeRepository
        }
        
        func addChallengeParticipant(challenge : inout Challenge, participant : User) {
            challenge.participants.append(participant)
            // FIXME: Call update method from ChallengeRepository
        }
        
        func removeChallengeParticipant(challenge : inout Challenge, participant : User) {
            challenge.participants.removeAll { $0.id == participant.id }
            // FIXME: Call update method from ChallengeRepository
        }
        
    }
}
