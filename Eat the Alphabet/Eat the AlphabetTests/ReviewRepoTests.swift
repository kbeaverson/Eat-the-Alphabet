//
//  ReviewRepoTests.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/7/17.
//

import XCTest
@testable import Eat_the_Alphabet
import Supabase

final class ReviewRepoTests: XCTestCase {
    var reviewRepo: ReviewRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()
        reviewRepo = ReviewRepository()
    }
    
    let testUserId = "74ab959f-ad2c-40f3-b1b2-0cc84341c5ca" // fred l
    let testReviewId = "59e81281-7878-4da5-9a28-2b290d8f2881" //
    let testExpId = "c2e6a3df-7825-4334-897f-5ab01a971fb1"
    let testRestaurantId = "d9844422-5c73-4b1d-82ee-f518cb694ec5" // Example Restaurant ID
    
    let testCrudReview = Review(
        id: "cfca5ee9-daa7-45dc-b3b8-cc968dd94b79",
        created_at: Date(),
        title: "Test Review",
        review: "This is a test review from User 1 (Fred L) for Experience 2 Challenhe 1",
        rating: 5,
        user_id: "74ab959f-ad2c-40f3-b1b2-0cc84341c5ca",
        experience_id: "da1b126b-70ca-45e4-842b-fdedb6caed55", // Example Experience ID
        order: "Example Dish 1"
    )

    func testFetchReviews() async throws {
        do {
            let reviews = try await reviewRepo.fetchReviews(byUser: testUserId)
            print("Fetched reviews: \(reviews)")
            XCTAssertFalse(reviews.isEmpty, "Reviews should not be empty")
        } catch {
            XCTFail("Failed to fetch reviews: \(error)")
            throw error
        }
    }
    
    func testFetchReviewsByExperience() async throws {
        do {
            let reviews = try await reviewRepo.fetchReviews(byExperience: testExpId)
            print("Fetched reviews for experience: \(reviews)")
            XCTAssertFalse(reviews.isEmpty, "Reviews for experience should not be empty")
            
        } catch {
            XCTFail("Failed to fetch reviews by experience: \(error)")
            throw error
        }
    }
    

    func testFetchReviewsByRestaurant() async throws {
        do {
            let reviews = try await reviewRepo.fetchReviews(byRestaurant: testRestaurantId)
            print("Fetched reviews for restaurant: \(reviews)")
            XCTAssertFalse(reviews.isEmpty, "Reviews for restaurant should not be empty")
        }
        catch {
            XCTFail("Failed to fetch reviews by restaurant: \(error)")
            throw error
        }
    }
    // 1
    func testCreateReview() async throws {
        do {
            try await reviewRepo.createReview(review: testCrudReview)
            print("Review successfully created.")
            let fetchedCreatedReview = try await reviewRepo.fetchReview(by: testCrudReview.id)
            XCTAssertEqual(fetchedCreatedReview?.id, testCrudReview.id, "Fetched review ID should match created review ID")
        } catch {
            XCTFail("Error creating review: \(error)")
            throw error
        }
    }
    
    // 2
    func testFetchReview() async throws {
        do {
            let fetchedReview = try await reviewRepo.fetchReview(by: testCrudReview.id)
            print("Fetched Review: \(String(describing: fetchedReview))")
            XCTAssertEqual(fetchedReview?.id, testCrudReview.id, "Fetched review ID should match test review ID")
        } catch {
            XCTFail("Error fetching review: \(error)")
            throw error
        }
    }
    
    // 3
    func testUpdateReview() async throws {
        var reviewToUpdate = testCrudReview
        reviewToUpdate.title = "Updated Test Review Title"
        do {
            try await reviewRepo.updateReview(review: reviewToUpdate, userId: testCrudReview.user_id)
            print("Review successfully updated.")
            let fetchedUpdatedReview = try await reviewRepo.fetchReview(by: reviewToUpdate.id)
            XCTAssertEqual(fetchedUpdatedReview?.title, reviewToUpdate.title, "Fetched updated review title should match the updated title")
        } catch {
            XCTFail("Error updating review: \(error)")
            throw error
        }
    }
    
    // 4
    func testDeleteReview() async throws {
        do {
            try await reviewRepo.deleteReview(by: testCrudReview.id)
            print("Review successfully deleted.")
            let fetchedDeletedReview = try await reviewRepo.fetchReview(by: testCrudReview.id)
            XCTAssertNil(fetchedDeletedReview, "Fetched review should be nil after deletion")
        } catch {
            XCTFail("Error deleting review: \(error)")
            throw error
        }
    }
    
}
