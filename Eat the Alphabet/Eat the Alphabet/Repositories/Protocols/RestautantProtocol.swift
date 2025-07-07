//
//  RestautantProtocol.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/30.
//

protocol RestaurantProtocol {
    // CRUD
    func getRestaurant(by id: String) async throws -> Restaurant
    func getRestaurant(byExperience experienceId: String) async throws -> Restaurant
    func getRestaurants(byChallenge challengeId: String) async throws -> [Restaurant]
    func getRestaurants(byCuisine cuisine: String) async throws -> [Restaurant]
    
    func createRestaurant(restaurant: Restaurant) async throws
    func updateRestaurant(restaurant: Restaurant) async throws
    func deleteRestaurant(id: String) async throws
    
    // Experience-related
    func getWithExperience(for restaurantId: String) async throws -> Restaurant
    
    // Review-related
    func getReviews(for restaurantId: String) async throws -> [Review]
    
    // Aggregation (optional)
    func getAverageRating(for restaurantId: String) async throws -> Float?
    
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
