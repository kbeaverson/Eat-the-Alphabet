import Foundation
import CoreLocation
import Supabase

// NOTE: API encapsulation for
class RestaurantRepository : RestaurantProtocol {
    func fetchRestaurant(by id: String) async throws -> Restaurant {
        print ("Fetching restaurant by id: \(id)")
        do {
            let restaurant: Restaurant = try await supabaseClient
                .from("RestaurantWithWKT")
                .select()
                .eq("id", value: id)
                .single()
                .execute()
                .value
            return restaurant
        } catch {
            print("Error fetching restaurant by id: \(error)")
            throw error
        }
    }
    
    func getRestaurant(byMapID mapID: String) async throws -> Restaurant {
        do {
            let restaurant: Restaurant = try await supabaseClient
                .from("Restaurant")
                .select()
                .eq("map_imported_id", value: mapID)
                .single()
                .execute()
                .value
            
            return restaurant
        } catch {
            print("Error fetching restaurant by map id: \(error)")
            throw error
        }
    }
    
    func fetchRestaurant(byExperience experienceId: String) async throws -> Restaurant? {
        do {
            let experience: Experience = try await supabaseClient
                .from("Experience")
                .select(
                    """
                    *, 
                    restaurant_id,
                    Restaurant (id, *)
                    """
                )
                .eq("id", value: experienceId)
                .single()
                .execute()
                .value
            
            return experience.restaurant // restaurant
        } catch {
            print("Error fetching restaurants by experience: \(error)")
            throw error
        }
    }
    
    func fetchRestaurants(byChallenge challengeId: String) async throws -> [Restaurant] {
        // each challenge has several experiences, each experience has a restaurant
        do {
            let experiences: [Experience] = try await supabaseClient
                .from("experiences")
                .select()
                .eq("challenge_id", value: challengeId)
                .execute()
                .value
            
            if experiences.isEmpty {
                print("No experiences found for challenge \(challengeId).")
            }
            
            let restaurantIds = experiences.map { $0.restaurant_id }
            let restaurants: [Restaurant] = try await supabaseClient
                .from("RestaurantWithWKT")
                .select()
                .in("id", values: restaurantIds)
                .execute()
                .value
            return restaurants
        } catch {
            print("Error fetching restaurants by challenge: \(error)")
            throw error
        }
    }
    
    func fetchRestaurants(byCuisine cuisine: String) async throws -> [Restaurant] {
        do {
            let restaurants: [Restaurant] = try await supabaseClient
                .from("RestaurantWithWKT")
                .select()
                .eq("cuisine", value: cuisine)
                .execute()
                .value
            
            return restaurants
        } catch {
            print("Error fetching restaurants by cuisine: \(error)")
            throw error
        }
    }
    
    func createRestaurant(restaurant: Restaurant) async throws -> Void {
        
        do {
            try await supabaseClient
                .from("Restaurant")
                .insert(restaurant)
                .execute()
            
            print("Restaurant successfully created.")
        } catch {
            
            print("Error creating restaurant: \(error)")
            throw error
        }
    }
    
    func updateRestaurant(restaurant: Restaurant) async throws {
        do {
            try await supabaseClient
                .from("Restaurant")
                .update(restaurant)
                .eq("id", value: restaurant.id)
                .execute()
            
            print("Restaurant successfully updated.")
        } catch {
            print("Error updating restaurant: \(error)")
            throw error
        }

    }
    
    func deleteRestaurant(id: String) async throws {
        do {
            try await supabaseClient
                .from("Restaurant")
                .delete()
                .eq("id", value: id)
                .execute()
                    
            print("Restaurant successfully deleted.")
        } catch {
            print("Error deleting restaurant: \(error)")
            throw error
        }
    }
    
//    func searchRestaurants(by name: String) async throws -> [Restaurant] {
//        <#code#>
//    }
//    
//    func filterRestaurants(cuisine: String?, maxPrice: Int?, minRating: Float?, within radius: Float?, from location: GeoPoint?) async throws -> [Restaurant] {
//        <#code#>
//    }
    
    func fetchReviews(for experienceId: String) async throws -> [Review] {
        do {
            let reviews: [Review] = try await supabaseClient
                .from("Review")
                .select()
                .eq("experience_id", value: experienceId)
                .execute()
                .value
                /** .select(
                    """
                    *,
                    experience_id
                    Experience(id, *)
                    """
                ) */

            return reviews
        } catch {
            print("Error fetching reviews for restaurant: \(error)")
            throw error
        }
    }
    
    func getRestaurantAddressWGS(for restaurantId: String) async throws -> CLLocationCoordinate2D {
        do {
            let restaurants: [Restaurant] = try await supabaseClient
                .from("RestaurantWithWKT")
                .select()
                .eq("id", value: restaurantId)
                .execute()
                .value
            
            guard let restaurant = restaurants.first else {
                throw NSError(domain: "RestaurantRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "Restaurant not found with id \(restaurantId)"])
            }
            
            guard let address_wgs = restaurant.address_wgs else {
                throw NSError(domain: "RestaurantRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "Address not found for restaurant with id \(restaurantId)"])
            }
            
            let coordinates = address_wgs.replacingOccurrences(of: "POINT(", with: "")
                .replacingOccurrences(of: ")", with: "")
                .split(separator: " ")
                .compactMap { Double($0) }
            
            guard coordinates.count == 2 else {
                throw NSError(domain: "RestaurantRepository", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid address format for restaurant with id \(restaurantId)"])
            }
            let latitude = coordinates[1]
            let longitude = coordinates[0]
            
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } catch {
            print("Error fetching restaurant address: \(error)")
            throw error
        }
    }
}
