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

final class RestaurantRepositoryTests: XCTestCase {
    let repo = RestaurantRepository()
    let testRestaurantId = "3a8c7df0-56f7-4f2f-bb67-937b8e13e7b1"
    let testExperienceId = "95c7b37f-f3a0-437a-8029-b31b21e85ee4"
    let testChallengeId = "2059d41a-42fc-4093-bb47-a7feb82bbfc1"
    let testCuisine = "Greek cuisine"

    func testGetRestaurantById() async throws {
        let restaurant = try await repo.getRestaurant(by: testRestaurantId)
        XCTAssertEqual(restaurant.id, testRestaurantId)
    }

    func testGetRestaurantByExperience() async throws {
        let restaurant = try await repo.getRestaurant(byExperience: testExperienceId)
        XCTAssertNotNil(restaurant)
    }

    func testGetRestaurantsByChallenge() async throws {
        let restaurants = try await repo.getRestaurants(byChallenge: testChallengeId)
        XCTAssertFalse(restaurants.isEmpty)
    }

    func testGetRestaurantsByCuisine() async throws {
        let restaurants = try await repo.getRestaurants(byCuisine: testCuisine)
        XCTAssertFalse(restaurants.isEmpty)
    }

    func testCRUD() async throws {
        // 创建
        let dummy = Restaurant(
            id: UUID().uuidString,
            name: "UnitTest Greek",
            created_at: Date(),
            cuisine: testCuisine,
            avg_per_cost: 100,
            map_imported_id: "dummy_map_id",
            map_imported_rating: nil,
            rating: 4.5,
            address_wgs: "POINT(-73.946823 40.807416)", //FIXME: GeoPoint(CLLocationCoordinate2D(latitude: 39.9612, longitude: -82.9988)), // 示例经纬度
            address_text: "123 Test St, Columbus, OH",
            details: "Unit test restaurant for CRUD",
            image_url: nil
        )
        try await repo.createRestaurant(restaurant: dummy)
        // 查询
        let fetched = try await repo.getRestaurant(by: dummy.id)
        XCTAssertEqual(fetched.name, "UnitTest Greek")
        // 更新
//        var updated = dummy
//        updated.name = "UnitTest Greek Updated"
//        try await repo.updateRestaurant(restaurant: updated)
//        let fetched2 = try await repo.getRestaurant(by: dummy.id)
//        XCTAssertEqual(fetched2.name, "UnitTest Greek Updated")
        // 删除
        try await repo.deleteRestaurant(id: dummy.id)
        do {
            _ = try await repo.getRestaurant(by: dummy.id)
            XCTFail("Should throw after deletion")
        } catch {
            // 预期抛出
        }
    }
}
