//
//  RestaurantRepositoryTests.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/7/8.
//

import XCTest
@testable import Eat_the_Alphabet
import Supabase
import CoreLocation

final class RestaurantRepoTest: XCTestCase {
    let repo = RestaurantRepository()
    let experienceRepo = ExperienceRepository()
    
    let testRestaurantId = "3a8c7df0-56f7-4f2f-bb67-937b8e13e7b1"
    let testExperienceId = "95c7b37f-f3a0-437a-8029-b31b21e85ee4"
    let testChallengeId = "2059d41a-42fc-4093-bb47-a7feb82bbfc1"
    let testCuisine = "Greek cuisine"
    
    let generatedUUID = "ebda3bea-2343-4810-8644-f4e842a59e0e"

    
    lazy var dummy = Restaurant(
        id: generatedUUID, // UUID().uuidString,
        name: "UnitTest Greek",
        created_at: Date(),
        cuisine: testCuisine,
        avg_per_cost: 100,
        map_imported_id: "dummy_map_id",
        map_imported_rating: nil,
        rating: 4,
        address_wgs: "POINT(-73.946823 40.807416)", //FIXME: GeoPoint(CLLocationCoordinate2D(latitude: 39.9612, longitude: -82.9988)), // 示例经纬度
        address_text: "123 Test St, Columbus, OH",
        details: "Unit test restaurant for CRUD",
        image_url: nil
    )
        

    func testGetRestaurantById() async throws {
        let restaurant = try await repo.fetchRestaurant(by: testRestaurantId)
        // print info
        print("Restaurant fetched: \(restaurant)")
        XCTAssertEqual(restaurant.id, testRestaurantId)
    }

    func testGetRestaurantByExperience() async throws {
        let restaurant: Restaurant? = try await repo.fetchRestaurant(byExperience: testExperienceId)
        if (restaurant != nil) {
            print("Restaurant from experience: \(String(describing: restaurant))")
        }
        XCTAssertNotNil(restaurant)
    }

    func testGetRestaurantsByChallenge() async throws {
        let experiences: [Experience] = try await experienceRepo.fetchExperiences(byChallenge: testChallengeId)
        // print("Experiences for challenge \(testChallengeId): \(experiences)")
        XCTAssertFalse(experiences.isEmpty, "No experiences found for challenge \(testChallengeId)")
        var restaurants : [Restaurant] = []
        for experience in experiences {
            if let restaurant = try await repo.fetchRestaurant(byExperience: experience.id) {
                restaurants.append(restaurant)
            }
        }
        // print("Restaurants for challenge \(testChallengeId): \(restaurants)")
        XCTAssertFalse(restaurants.isEmpty, "No restaurants found for challenge \(testChallengeId)")
    }

    func testGetRestaurantsByCuisine() async throws {
        let restaurants = try await repo.fetchRestaurants(byCuisine: testCuisine)
        // print("Restaurants for cuisine \(testCuisine): \(restaurants)")
        XCTAssertFalse(restaurants.isEmpty)
    }

    
    func testFetchReviews() async throws {
        let reviews = try await repo.fetchReviews(for: testExperienceId)
        if reviews.isEmpty {
            print("No reviews found for experience \(testExperienceId).")
        } else {
            print("Reviews for experience \(testExperienceId): \(reviews)")
        }
        XCTAssertFalse(reviews.isEmpty, "Expected to find reviews for experience \(testExperienceId)")
    }
    
    func testCreateRestaurant() async throws {
        // 创建
        try await repo.createRestaurant(restaurant: dummy)
    }
    
    func testReadRestaurant() async throws {
        // 查询
        let restaurant = try await repo.fetchRestaurant(by: dummy.id)
        print("Restaurant fetched: \(restaurant)")
        XCTAssertEqual(restaurant.id, dummy.id)
    }
    
    // in theory, a restaurant's information should never be changed, should only support CRD
    func testUpdateRestaurant() async throws {
        // 更新
        let updated = Restaurant(
            id: "ebda3bea-2343-4810-8644-f4e842a59e0e", // UUID().uuidString,
            name: "UnitTest Greek Updated",
            created_at: Date(),
            cuisine: testCuisine,
            avg_per_cost: 100,
            map_imported_id: "dummy_map_id",
            map_imported_rating: nil,
            rating: 4,
            address_wgs: "POINT(-73.946823 40.807416)", //FIXME: GeoPoint(CLLocationCoordinate2D(latitude: 39.9612, longitude: -82.9988)), // 示例经纬度
            address_text: "123 Test St, Columbus, OH",
            details: "Unit test restaurant for CRUD",
            image_url: nil
        )
        try await repo.updateRestaurant(restaurant: updated)
        
        let fetched = try await repo.fetchRestaurant(by: dummy.id)
        print("Updated restaurant fetched: \(fetched)")
        XCTAssertEqual(fetched.name, "UnitTest Greek Updated")
    }
    
    func testDeleteRestaurant() async throws {
        // 删除
        try await repo.deleteRestaurant(id: dummy.id)
        do {
            _ = try await repo.fetchRestaurant(by: dummy.id)
            XCTFail("Should throw after deletion")
        } catch {
            print("Restaurant successfully deleted, caught expected error: \(error)")
        }
    }
    
    func testGetRestaurantAddrWGS() async throws {
        let location : CLLocationCoordinate2D = try await repo.getRestaurantAddressWGS(for: testRestaurantId)
        
        print("Restaurant address WGS for \(testRestaurantId): \(location)")
    }
}
