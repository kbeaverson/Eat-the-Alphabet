//
//  ExperienceListViewModel.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/24/25.
//
import Foundation
import CoreLocation

class ExperienceListViewModel: ObservableObject {
    @Published var experiences : [Experience] = []
    // TODO: Consider monitoring loading status/errors with other published vars?
    
    private let reviewRepository: ReviewRepository
    private let repository: ExperienceRepository
    private let accountRepository: AccountRepository
    private let challengeRepository: ChallengeRepository
    
    init() {
        self.reviewRepository = ReviewRepository()
        self.repository = ExperienceRepository()
        self.accountRepository = AccountRepository()
        self.challengeRepository = ChallengeRepository()
    }
    
    @MainActor
    func fetchExperiences(challengeId: String) async throws{
        do {
            let fetchedExperiences: [Experience] = try await repository.fetchExperiences(byChallenge: challengeId)
            print("Fetched experiences: \(fetchedExperiences.count) for challenge \(challengeId)")
            self.experiences = fetchedExperiences
        } catch {
            print("Error fetching experience: \(error)")
            throw error
        }
    }

    public func getCLLCoordinates(for challengeId: String) async -> CLLocationCoordinate2D? {
        do {
            let location: CLLocationCoordinate2D = try await challengeRepository.getChallengeLocation(challengeId: challengeId)
            print("Fetched challenge location: \(location.latitude), \(location.longitude)")
            return location
        } catch {
            print("Error fetching challenge location: \(error)")
            return nil
        }
    }
    
    public func joinExperience(experienceId: String) async throws {
        do {
            // check participation first
            let isParticipating = try await repository.checkParticipation(userId: supabaseClient.auth.currentUser?.id.uuidString.lowercased() ?? "", experienceId: experienceId)
            if isParticipating {
                print("Already participating in experience \(experienceId)")
                return
            }
            // Join the experience
            try await repository.addParticipant(userId: supabaseClient.auth.currentUser?.id.uuidString.lowercased() ?? "", to: experienceId)
            print("Successfully joined experience \(experienceId)")
        } catch {
            print("Error joining experience: \(error)")
            throw error
        }
    }
    
    public func leaveExperience(experienceId: String) async throws {
        do {
            let isParticipating = try await repository.checkParticipation(userId: supabaseClient.auth.currentUser?.id.uuidString.lowercased() ?? "", experienceId: experienceId)
            if !isParticipating {
                print("Not participating in experience \(experienceId)")
                return
            }
            // Leave the experience
            try await repository.removeParticipant(userId: supabaseClient.auth.currentUser?.id.uuidString.lowercased() ?? "", from: experienceId)
            print("Successfully left experience \(experienceId)")
        } catch {
            print("Error leaving experience: \(error)")
            throw error
        }
    }
}
