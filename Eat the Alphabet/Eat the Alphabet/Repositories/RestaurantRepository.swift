import Foundation
import CoreLocation
import Supabase

// NOTE: API encapsulation for
class RestaurantRepository : RestaurantProtocol {
    
    let client: SupabaseClient
    init(client: SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
    }
    
    func createRestaurant(restaurant: Restaurant) async throws -> Void {
        do {
            try await client
                .from("Restaurant")
                .insert(restaurant)
                .execute()
            
            print("Restaurant successfully created.")
        } catch {
            
            print("Error creating restaurant: \(error)")
            throw error
        }
    }
    
    func getRestaurant(by id: String) async throws -> Restaurant {
        do {
            let restaurant: Restaurant = try await client
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
    
    func updateRestaurant(restaurant: Restaurant) async throws {
        do {
            try await client
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
            try await client
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
    
    func getExperiences(for restaurantId: String) async throws -> [Experience] {
        do {
            let restaurantWithExperiences: Restaurant = try await client
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
            
            return restaurantWithExperiences.experiences ?? []
        } catch {
            print("Error fetching experiences for restaurant: \(error)")
            throw error
        }
    }
    
    // TODO: technique revise
    func getAverageRating(for restaurantId: String) async throws -> Float? {
        do {
            let restaurant: Restaurant = try await client
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
