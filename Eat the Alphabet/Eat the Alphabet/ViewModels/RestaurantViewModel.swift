//
//  RestaurantViewModel.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/14.
//
import SwiftUI
import CoreLocation

// NOTE: RestaurantViewModel is a view model for the Restaurant model, it contains UI related data and logic.
class RestaurantViewModel: Identifiable, ObservableObject {
    private let restaurantRepository: RestaurantRepository = RestaurantRepository()
    @Published var restaurant: Restaurant?
    
    public func fetchRestaurant(byId restaurantId: String) async throws {
        // Fetch restaurant from the repository
        let fetchedRestaurant = try await restaurantRepository.fetchRestaurant(by: restaurantId)
        print("Fetched restaurant: \(fetchedRestaurant)")
        await MainActor.run {
            // Update the restaurant property on the main thread
            self.restaurant = fetchedRestaurant
        }
    }
    
    static func getDistanceInKm(selfCoord2d: CLLocationCoordinate2D, targetCoord2d: CLLocationCoordinate2D) -> Double {
        // calculate distance from user location (both passed in)
        let userLocation = CLLocation(latitude: selfCoord2d.latitude, longitude: selfCoord2d.longitude)
        let targetLocation = CLLocation(latitude: targetCoord2d.latitude, longitude: targetCoord2d.longitude)
        let distanceInMeters = userLocation.distance(from: targetLocation)
        let distanceInKm = distanceInMeters / 1000
        return distanceInKm
    }
    
    // Converts current view model back to model
//    func toModel(with geoLocation: GeoPoint) -> Restaurant {
//        return Restaurant(
//            id: self.id,
//            name: self.name,
//            cuisine: self.cuisine,
//            price: 30, // or add this field to VM
//            rating: 4.5, // or computed/assigned
//            address: geoLocation,
//            details: self.details,
//            imageUrl: self.imageUrl
//        )
//    }

    // TODO: other methods, CRUD operations, etc.
}
