import Foundation
import CoreLocation
import Supabase

// NOTE: API encapsulation for
class RestaurantRepository : RestaurantProtocol {
    
    func getRestaurant(by id: String) async throws -> Restaurant {
        do {
            let restaurant: Restaurant = try await supabaseClient
                .from("Restaurant")
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
    
    func getRestaurant(byExperience experienceId: String) async throws -> Restaurant {
        do {
            let restaurant: Restaurant = try await supabaseClient
                .from("Restaurant")
                .select(
                    """
                    *,
                    experiences(*)
                    """
                )
                .eq("experiences.id", value: experienceId)
                .single()
                .execute()
                .value
            
            return restaurant
        } catch {
            print("Error fetching restaurants by experience: \(error)")
            throw error
        }
    }
    
    func getRestaurants(byChallenge challengeId: String) async throws -> [Restaurant] {
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
                .from("Restaurant")
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
    
    func getRestaurants(byCuisine cuisine: String) async throws -> [Restaurant] {
        do {
            let restaurants: [Restaurant] = try await supabaseClient
                .from("Restaurant")
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
    
    func getWithExperience(for restaurantId: String) async throws -> Restaurant {
        do {
            let restaurantWithExperience: Restaurant = try await supabaseClient
                .from("Restaurant")
                .select(
                    """
                    *,
                    experiences(*)
                    """
                )
                .eq("id", value: restaurantId)
                .single()
                .execute()
                .value
            
            return restaurantWithExperience
        } catch {
            print("Error fetching experiences for restaurant: \(error)")
            throw error
        }
    }
    
    func getReviews(for restaurantId: String) async throws -> [Review] {
        do {
            let reviews: [Review] = try await supabaseClient
                .from("Review")
                .select(
                    """
                    *,
                    experience(*)
                    """
                )
                .eq("experience.id", value: restaurantId)
                .execute()
                .value
            return reviews
        } catch {
            print("Error fetching reviews for restaurant: \(error)")
            throw error
        }
    }
    
    // TODO: technique revise
    func getAverageRating(for restaurantId: String) async throws -> Float? {
        do {
            let restaurant: Restaurant = try await supabaseClient
                .from("Restaurant")
                .select(
                    """
                    avg(map_imported_rating) as avg_map_imported_rating,
                    avg(rating) as avg_rating
                    """
                )
                .eq("id", value: restaurantId)
                .single()
                .execute()
                .value
            
            return restaurant.map_imported_rating ?? restaurant.rating ?? nil
        } catch {
            print("Error fetching average rating for restaurant: \(error)")
            throw error
        }
    }

}
