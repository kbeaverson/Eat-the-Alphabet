//
//  RestaurantViewModel.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/14.
//
import SwiftUI
import CoreLocation

// NOTE: RestaurantViewModel is a view model for the Restaurant model, it contains UI related data and logic.
struct RestaurantViewModel: Identifiable {
    // private let restaurantRepository: RestaurantRepository = RestaurantRepository()
    var id: String
    var name: String
    var cuisine: String
    var details: String?
    var imageUrl: String?
    var distance: Double? // distance in km from user location, nil if not available
    
    // mapping database model to view model
    init(restaurant: Restaurant, userLocation: CLLocationCoordinate2D?) {
        self.id = restaurant.id
        self.name = restaurant.name
        self.cuisine = restaurant.cuisine
        self.details = restaurant.details// FIXME: add details to the database table and model
        self.imageUrl = restaurant.imageUrl
        if let userCoord = userLocation {
            self.distance = RestaurantViewModel.getDistanceInKm(
                selfCoord2d: userCoord,
                targetCoord2d: CLLocationCoordinate2D(
                    latitude: restaurant.address.latitude,
                    longitude: restaurant.address.longitude
                )
            )
        } else {
            self.distance = nil
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
}
