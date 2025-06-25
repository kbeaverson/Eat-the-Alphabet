import Foundation
import CoreLocation

// NOTE: API encapsulation for 
class RestaurantRepository {
    static let shared = RestaurantRepository()
    
    private let experienceRepository = ExperienceRepository.shared
    
    // Fetch all restaurants
    func loadAllRestaurants(completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        Task {
            do {
                let response: [Restaurant] = try await SupabaseManager.shared.client
                    .from("restaurants")
                    .select()
                    .execute()
                    .value
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func loadRestaurantById(id: String, completion: @escaping (Result<Restaurant, Error>) -> Void) {
        Task {
            do {
                let response: Restaurant = try await SupabaseManager.shared.client
                    .from("restaurants")
                    .select()
                    .eq("id", value: id)
                    .execute()
                    .value
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Fetch restaurant by its experience ID
    func loadRestaurantByExperienceId ( experience_id: String, completion: @escaping (Result<Restaurant, Error>) -> Void ) {
        Task {
            do {
                let response: Restaurant = try await SupabaseManager.shared.client
                    .from("experience")
                    .select()
                    .eq("id", value: experience_id)
                    .execute()
                    .value as Restaurant
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
        
    func loadRestaurantsByChallengeId(challengeId: String, completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        experienceRepository.loadExperiencesByChallengeId(challengeId: challengeId) { result in
            switch result {
            case .success(let experiences):
                let restaurantIds = experiences.map { $0.restaurant.id }
                var restaurants: [Restaurant] = []
                var encounteredError: Error? = nil
                let group = DispatchGroup()

                for id in restaurantIds {
                    group.enter()
                    self.loadRestaurantById(id: id) { result in
                        switch result {
                        case .success(let restaurant):
                            restaurants.append(restaurant)
                        case .failure(let error):
                            // Capture the first error encountered
                            if encounteredError == nil {
                                encounteredError = error
                            }
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    if let error = encounteredError {
                        completion(.failure(error))
                    } else {
                        completion(.success(restaurants))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }



//    func addRestaurant(_ restaurant: Restaurant) {
//        // TODO: add restaurant to the database
//    }
    func addRestaurant(_ restaurant: Restaurant, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let response = try await SupabaseManager.shared.client
                    .from("restaurants")
                    .insert(restaurant)
                    .execute()
                // Check if the response contains an error
                completion(.success(())) // Simulate success
            } catch {
                completion(.failure(error))
            }
        }
    }
        
    func deleteRestaurant(by id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let response = try await SupabaseManager.shared.client
                    .from("restaurants")
                    .delete()
                    .eq("id", value: id)
                    .execute()
                // Check if the response contains an error
                completion(.success(())) // Simulate success
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func updateRestaurant(_ restaurant: Restaurant, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let response = try await SupabaseManager.shared.client
                    .from("restaurants")
                    .update(restaurant)
                    .eq("id", value: restaurant.id)
                    .execute()
                // Check if the response contains an error
                completion(.success(())) // Simulate success
            } catch {
                completion(.failure(error))
            }
        }
    }
}
