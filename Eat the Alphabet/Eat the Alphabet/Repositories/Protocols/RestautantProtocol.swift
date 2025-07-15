//
//  RestautantProtocol.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/30.
//

protocol RestaurantProtocol {
    // basic CRUD
    func fetchRestaurant(by id: String) async throws -> Restaurant // WORK
    func createRestaurant(restaurant: Restaurant) async throws // 
    func updateRestaurant(restaurant: Restaurant) async throws
    func deleteRestaurant(id: String) async throws
    
    // advanced R
    func fetchRestaurant(byExperience experienceId: String) async throws -> Restaurant? // WORK
    func fetchRestaurants(byChallenge challengeId: String) async throws -> [Restaurant] // WORK
    func fetchRestaurants(byCuisine cuisine: String) async throws -> [Restaurant] // WORK
    
    // Review-related
    func fetchReviews(for experienceId: String) async throws -> [Review]
    
    // Aggregation (optional)
//    func getAverageRating(for restaurantId: String) async throws -> Int?
    
    // Search & filter
//    func searchRestaurants(by name: String) async throws -> [Restaurant]
//    func filterRestaurants(
//        cuisine: String?,
//        maxPrice: Int?,
//        minRating: Float?,
//        within radius: Float?,
//        from location: GeoPoint?
//    ) async throws -> [Restaurant]
}
