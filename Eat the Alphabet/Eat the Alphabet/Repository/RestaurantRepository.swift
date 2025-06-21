import Foundation
import CoreLocation

// NOTE: API encapsulation for 
class RestaurantRepository {
    // FIXME: placeholder function for fetching restaurants
    func fetchAllRestaurants( completion: @escaping ([Restaurant]) -> void ) {
        // FIXME: this simulates fetching, get a real one
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            let mockRestaurant = Restaurant(
                id: "1",
                name: "Mock Restaurant",
                cuisine: "Mock Cuisine",
                address: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                imageUrl: "https://example.com/image.jpg",
                details: "This is a mock restaurant for testing purposes."
            )
            completion([mockRestaurant])
        }
    }

    func addRestaurant(_ restaurant: Restaurant) {
        // TODO: add restaurant to the database
    }
    
    func deleteRestaurant(by id: String) {
        // TODO: delete restaurant by ID from the database
    }
    
    func updateRestaurant(_ restaurant: Restaurant) {
        // TODO: update restaurant in the database with the provided restaurant object
    }
}