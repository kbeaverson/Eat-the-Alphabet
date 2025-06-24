//
//  RestaurantViewModel.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/14.
//
import SwiftUI
import CoreLocation

// NOTE: RestaurantViewModel is a view model for the Restaurant model, it contains UI related data and logic.
class RestaurantListViewModel: ObservableObject {
    @Published var restaurants: [RestaurantViewModel] = []

    private let repository: RestaurantRepository = RestaurantRepository()
    
    func loadRestaurants(userLocation: CLLocationCoordinate2D?) {
        // Load restaurants from the repository
        // TODO: implement get restaurants ACCORDING to cretetias (eg. aphabet, cuisine, challenge_id)
    }
}
