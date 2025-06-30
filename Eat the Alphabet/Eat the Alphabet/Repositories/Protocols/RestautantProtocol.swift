//
//  RestautantProtocol.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/30.
//

protocol RestaurantProtocol {
    // CRUD
    func createRestaurant(restaurant: Restaurant) async throws
    func getRestaurant(by id: String) async throws -> Restaurant
    func updateRestaurant(restaurant: Restaurant) async throws
    func deleteRestaurant(id: String) async throws
    
    // Search & filter
//    func searchRestaurants(by name: String) async throws -> [Restaurant]
//    func filterRestaurants(
//        cuisine: String?,
//        maxPrice: Int?,
//        minRating: Float?,
//        within radius: Float?,
//        from location: GeoPoint?
//    ) async throws -> [Restaurant]
    
    // Experience-related
    func getExperiences(for restaurantId: String) async throws -> [Experience]
    
    // Aggregation (optional)
    func getAverageRating(for restaurantId: String) async throws -> Float?
}
