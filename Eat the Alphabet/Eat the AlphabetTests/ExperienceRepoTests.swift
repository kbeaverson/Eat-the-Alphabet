//
//  ExperienceRepoTest.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/7/14.
//

import Foundation
import XCTest
@testable import Eat_the_Alphabet
import Supabase

final class ExperienceRepoTest: XCTestCase {
    let repo : ExperienceRepository = ExperienceRepository()
    
//    let testNewExperience = Experience(
//        id: "7f6e7f93-a268-41c2-b961-1d2896f0ff9f",
//        created_at: Date(),
//        status: "incomplete",
//        restaurant_id: "14b76d6d-fb81-4a95-a616-38870e7d81eb", // restaurant lavazza
//        challenge_id: "7c718dd0-8af1-4636-9f0e-97fbd2dff7eb", // Shanghai Challenge
//        letter: "Z"
//    )
    
    let testChallengeId = "7c718dd0-8af1-4636-9f0e-97fbd2dff7eb" // the one in shanghai
    let testExperienceId = "c2e6a3df-7825-4334-897f-5ab01a971fb1" // `Playground` (near 一大会址)
    let testRestaurantId = "d9844422-5c73-4b1d-82ee-f518cb694ec5" // ch2, exp1' `Playground` restaurant
    let testUserId = "16dfab99-d548-4a4c-96bb-27f08589b84f" // user 3
    
    let testNotAssociatedRestaurantId = "a1c62ea4-b029-4867-90d6-0ad0d87bb280" // not associated with any challenge or experience
    let testInsertExperience: Experience = Experience(
        id: "207d9889-f2b0-4812-9f24-e6c916a1cefa",
        created_at: Date(),
        status: "incomplete",
        restaurant_id: "a1c62ea4-b029-4867-90d6-0ad0d87bb280",
        challenge_id: "7c718dd0-8af1-4636-9f0e-97fbd2dff7eb", // Shanghai Challenge
        letter: "W"
    )
    
    
    
    func testFetchExperienceById() async throws {
        do {
            let experience = try await repo.fetchExperience(by: testExperienceId)
            XCTAssertNotNil(experience)
            XCTAssertEqual(experience?.id, testExperienceId)
        } catch {
            XCTFail("Failed to fetch experience by id: \(error)")
            throw error
        }
    }
    
    func testCreateExperinece() async throws {
        do {
            try await repo.createExperience(experience: testInsertExperience)
            let fetchedExperience = try await repo.fetchExperience(by: testInsertExperience.id)
            XCTAssertNotNil(fetchedExperience)
            XCTAssertEqual(fetchedExperience?.id, testInsertExperience.id)
        } catch {
            XCTFail("Failed to create experience: \(error)")
            throw error
        }
    }
    
    func testUpdateExperience() async throws {
        do {
            var experienceToUpdate = testInsertExperience
            experienceToUpdate.status = "complete"
            try await repo.updateExperience(experience: experienceToUpdate)
            
            let updatedExperience = try await repo.fetchExperience(by: experienceToUpdate.id)
            
            XCTAssertNotNil(updatedExperience)
            XCTAssertEqual(updatedExperience?.status, "complete")
        }
        catch {
            XCTFail("Failed to update experience: \(error)")
            
            throw error
        }
    }
    
    func testFetchRestaurantForExperience() async throws {
        do {
            let restaurant : Restaurant? = try await repo.fetchRestaurant(for: testExperienceId)
            if restaurant != nil {
                XCTAssertEqual(restaurant?.id, testRestaurantId)
            }
        }
        catch{
            XCTFail("Failed to fetch restaurant: \(error)")
            throw error
        }
    }
    
    // add participants to the test experience
    func testAddParticipants() async throws {
        do {
            try await repo.addParticipant(userId: testUserId, to: testInsertExperience.id)
            let participants: [Account]? = try await repo.fetchParticipants(for: testInsertExperience.id)
            for participant in participants ?? [] {
                print("Participant ID: \(participant.id), Name: \(participant.username ?? "Unknown")")
            }
            XCTAssertNotNil(participants)
            XCTAssertTrue(participants?.contains(where: { $0.id == testUserId }) ?? false)
        } catch {
            XCTFail("Failed to add participant: \(error)")
            
            throw error
        }
    }
            
    
    func testFetchParticipants() async throws {
        do {
            let participants: [Account]? = try await repo.fetchParticipants(for: testExperienceId)
            print("Fetched Participants for Experience \(testExperienceId): \(String(describing: participants))")
        } catch {
            XCTFail("Failed to fetch participants: \(error)")
            throw error
        }
    }
    
    func testRemoveParticipant() async throws {
        do {
            try await repo.removeParticipant(userId: testUserId, from: testInsertExperience.id)
            let participants: [Account]? = try await repo.fetchParticipants(for: testInsertExperience.id)
            XCTAssertFalse(participants?.contains(where: { $0.id == testUserId }) ?? true)
        } catch {
            XCTFail("Failed to remove participant: \(error)")
            throw error
        }
    }
    
    func testFetchReviewsForExperience() async throws {
        do {
            let reviews: [Review]? = try await repo.fetchReviews(for: testExperienceId)
            print("Fetched Reviews for Experience \(testExperienceId): \(String(describing: reviews))")
            XCTAssertNotNil(reviews)
            
        } catch {
            XCTFail("Failed to fetch reviews for experience: \(error)")
            throw error
        }
    }
    
    func testRemoveExperience() async throws {
        do {
            try await repo.deleteExperience(id: testInsertExperience.id)
            let deletedExperience = try await repo.fetchExperience(by: testInsertExperience.id)
            XCTAssertNil(deletedExperience, "Experience should be deleted")
        } catch {
            XCTFail("Failed to delete experience: \(error)")
            throw error
        }
    }
}

