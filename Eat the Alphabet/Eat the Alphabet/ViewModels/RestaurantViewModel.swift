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
    
    // mapping database model to view model
    init(restaurant: Restaurant, userLocation: CLLocationCoordinate2D?) {
        self.id = restaurant.id
        self.name = restaurant.name
        self.cuisine = restaurant.cuisine
        self.details = restaurant.details// FIXME: add details to the database table and model
        self.imageUrl = restaurant.image_url
//        if let userCoord = userLocation {
//            self.distance = RestaurantViewModel.getDistanceInKm(
//                selfCoord2d: userCoord,
//                targetCoord2d: CLLocationCoordinate2D(
//                    latitude: restaurant.address_wgs.latitude,
//                    longitude: restaurant.address_wgs.longitude
//                )
//            )
//        } else {
//            self.distance = nil
//        }
    public func fetchRestaurant(byId restaurantId: String) async throws {
        // Fetch restaurant from the repository
        let fetchedRestaurant = try await restaurantRepository.getRestaurant(by: restaurantId)
        self.restaurant = fetchedRestaurant
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
