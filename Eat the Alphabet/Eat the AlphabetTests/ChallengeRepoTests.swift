//
//  ChallengeRepoTest.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/7/12.
//


import XCTest
@testable import Eat_the_Alphabet
import Supabase
import CoreLocation

final class ChallengeRepoTest: XCTestCase {
    var challengeRepo: ChallengeRepository = ChallengeRepository()
    
    lazy var testCrudChallenge = Challenge(
        id: "42aa4b8c-207f-4300-88c1-b2fbe959ecf0",
        title: "Test Challenge",
        center_wgs: "POINT(121.469435 31.224894)", // First Commitee Meeting Location
        radius: 4.5,
        created_at: Date(),
        description: "This is a test challenge")
    
    let testUserId = "e083fbdd-04e0-4b1f-a31a-deb546756c71" // Ronald L
    let testChallengeID = "7c718dd0-8af1-4636-9f0e-97fbd2dff7eb" // Shanghai Challenge
    let testParticipantId = "5bd1ae39-93e1-49a2-b1c0-ec4830d866ab" // test user 01
    
    let testLetter : Character = "Z"
    
    
    func testCreateChallenge() async throws {
        try await challengeRepo.createChallenge(challenge: testCrudChallenge)
    }
    
    func testFetchChallenge() async throws {
        let challenge = try await challengeRepo.fetchChallenge(by: testCrudChallenge.id)
        
        print("Fetched Challenge: \(challenge)")
        XCTAssertEqual(challenge.id, testCrudChallenge.id)
    }
    
    func testUpdateChallenge() async throws {
        var updatedChallenge = testCrudChallenge
        updatedChallenge.title = "Updated Test Challenge"
        
        try await challengeRepo.updateChallenge(challenge: updatedChallenge)
        
        let fetchedChallenge = try await challengeRepo.fetchChallenge(by: updatedChallenge.id)
        XCTAssertEqual(fetchedChallenge.title, "Updated Test Challenge")
    }
    
    func testDeleteChallenge() async throws {
        try await challengeRepo.deleteChallenge(id: testCrudChallenge.id)
        do {
            _ = try await challengeRepo.fetchChallenge(by: testCrudChallenge.id)
            XCTFail("Challenge should have been deleted")
        } catch {
            // Expected error, challenge was deleted
            print("Challenge successfully deleted.")
        }
    }

    func testFetchChallengesByUserId() async throws {
        let userId = testUserId
        let challenges = try await challengeRepo.fetchChallenges(byUser: userId)
        for challenge in challenges {
            print("Fetched Challenge: \(challenge)")
        }
        XCTAssertNotNil(challenges)
    }
    
    func testFetchChallengesWithExperiences() async throws {
        let challenge = try await challengeRepo.fetchWithExperiences(byChallengeId: testChallengeID)
        print("Fetched Challenge with Experiences: \(challenge)")
        XCTAssertNotNil(challenge)
    }
    
    func testFetchOnlyExperiencesByChallengeId() async throws {
        let experiences = try await challengeRepo.fetchExperiences(byChallengeId: testChallengeID)
        for experience in experiences {
            print("Fetched Experiences: \(experience)")
        }
        XCTAssertNotNil(experiences)
    }
    
    func testFetchExperienceByLetter() async throws {
        let experience = try await challengeRepo.fetchExperience(byLetter: testLetter, in: testChallengeID)
        print("Fetched Experience by Letter: \(String(describing: experience))")
        XCTAssertNotNil(experience)
    }
    
    func testFetchParticipants() async throws {
        // let challengeWithParticipants = try await challengeRepo.fetchWithParticipants(byChallengeId: testChallengeID)
        let participants : [Account]? = try await challengeRepo.fetchParticipants(byChallengeId: testChallengeID)
        for participant in participants ?? [] {
            print("Fetched Participant: \(participant)")
        }
        XCTAssertNotNil(participants)
    }
    
    func testCheckParticipation() async throws {
        let isParticipated = try await challengeRepo.checkParticipation(userId: testUserId, challengeId: testChallengeID)
        print("Is User Participated: \(isParticipated)")
        XCTAssertNotNil(isParticipated)
    }
    
    func testJoinChallenge() async throws {
        try await challengeRepo.addParticipant(
            userId: testParticipantId,
            challengeId: testChallengeID
        )
        let isParticipated = try await challengeRepo.checkParticipation(userId: testParticipantId, challengeId: testChallengeID)
        print("Is User Participated after joining: \(isParticipated)")
        XCTAssertTrue(isParticipated)
    }
    
    func testRemoveParticipant() async throws {
        try await challengeRepo.removeParticipant(
            userId: testParticipantId,
            challengeId: testChallengeID
        )
        let isParticipated = try await challengeRepo.checkParticipation(userId: testParticipantId, challengeId: testChallengeID)
        print("Is User Participated after leaving: \(isParticipated)")
        XCTAssertFalse(isParticipated)
    }
    
    func testFetchAvailableLetters() async throws {
        // LESS EFFICIENT METHOD: get experiences first, then extract letters
        let lettersCompleted: [String] = try await challengeRepo.fetchExperienceLetters(in: testChallengeID, status: "completed")
        let lettersIncomplete: [String] = try await challengeRepo.fetchExperienceLetters(in: testChallengeID, status: "incomplete")
        
        print("Completed Letters: \(lettersCompleted)")
        print("Incomplete Letters: \(lettersIncomplete)")
        XCTAssertFalse(lettersCompleted.isEmpty, "Available letters should not be empty")
    }
    
    func testGetChallengeLocation() async throws {
        let location: CLLocationCoordinate2D = try await challengeRepo.getChallengeLocation(challengeId: testChallengeID)
        print("Challenge Location: \(location.latitude), \(location.longitude)")
        XCTAssertNotNil(location, "Challenge location should not be nil")
    }
}

