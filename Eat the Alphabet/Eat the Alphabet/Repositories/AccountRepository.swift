//
//  UserRepository.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//

import Foundation
import Supabase

class AccountRepository : AccountProtocol {
    static let shared = AccountRepository()
    
    func getFriendsCount(of userId: String) async throws -> Int {
            do {
                let count: Int? = try await supabaseClient
                    .from("Account")
                    .select(
                        """
                        *, 
                        friends (*)
                        """)
                    .eq("id", value: userId)
                    .execute()
                    .count
                guard let count = count else {
                    print("Error fetching friends count")
                    throw NSError(domain: "AccountRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch friends count"])
                }
                return count
            } catch {
                print("Error fetching friends count: \(error)")
                throw error
                    
            }
        }
    

    // 1 Create User
//    func createAccount(account: Account) async throws-> Void {
//        do {
//            try await supabaseClient
//                .from("Account")
//                .insert(account)
//                .execute()
//        } catch {
//            print("Error creating user: \(error)")
//            throw error
//        }
//    }
    
    // 2 Fetch User by id
    func fetchAccount(byId id: String) async throws -> Account {
        do {
            let account: Account = try await supabaseClient
                .from("Account")
                .select("id, created_at, username, display_name, profile_image_url, phone_number, email")
            // FIXME: Temporarily doesn't retrieve address because this data needs decoded separately
                .eq("id", value: id)
                .single()
                .execute()
                .value
            return account
        } catch {
            print("Error fetching user by id: \(error)")
            throw error
        }
    }
    
    // 2 Fetch User by username
    func fetchAccount(byUsername username: String) async throws -> Account {
        do {
            let account: Account = try await supabaseClient
                .from("Account")
                .select()
                .eq("username", value: username)
                .single()
                .execute()
                .value
            return account
        } catch {
            print("Error fetching user by username: \(error)")
            throw error
        }
    }
    
    
    
    // 3 update Account by id
    func updateAccount(account: Account) async throws -> Void{
        do {
            try await supabaseClient
                .from("Account")
                .update(account)
                .eq("id", value: account.id)
                .execute()
        } catch {
            print("Error updating user: \(error)")
            throw error
        }
    }
    
    // 4 Delete User
    func deleteAccount(byId id: String) async throws-> Void {
        try? await supabaseClient
            .from("Accounts")
            .delete()
            .eq("id", value: id)
            .execute()
            .value
    }

    
    // related data, via foreign keys
    // get User's Challenges TEST
    func fetchChallenges(for userId: String) async throws -> [Challenge]? {
        do {
            // NOTE: to debug, use hte JSONArray instead of the target model (or array of it)
            let accountWithChallenges : Account = try await supabaseClient
                .from("Account")
                .select("""
                    *,
                    id,
                    Challenge (id, *)
                """)
                .eq("id", value: userId)
                .single()
                .execute()
                .value
            
            return accountWithChallenges.challenges// results.map { $0.Challenge }
        } catch {
            print("Error fetching challenges: \(error)")
            throw error
        }
    }
    

    
    // get User's Experiences //FIXME: Not presently functional, replaced with fetchAllExperiences
    func fetchExperiences(for userId: String) async throws -> [Experience]? {
        do {
            let accountWithExperiences: Account = try await supabaseClient
                .from("Account")
                .select(
                    """
                    id, *,
                    Experience (
                        id, *
                    )
                    """
                )
                .eq("id", value: userId)
                .single()
                .execute()
                .value
            return accountWithExperiences.experiences // results.map { $0.Experience }
        } catch {
            print("Error fetching experiences: \(error)")
            throw error
        }
    }
    
    // get User's Reviews //FIXME: Not presently functional, replaced with fetchReviews
    func fetchReviews(for userId: String) async throws -> [Review]? {
        do {
            
            let accountWithReviews: Account = try await supabaseClient
                .from("Account")
                .select(
                    """
                    *,
                    id,
                    Review (
                        user_id,*
                    )
                    """
                )
                .eq("id", value: userId)
                .single()
                .execute()
                .value
            
            return accountWithReviews.reviews /**accountWithReviews.first?.reviews ?? []*/
        } catch {
            print("Error fetching reviews: \(error)")
            throw error
        }
    }
    
    func fetchAllExperiences(for userID: String) async throws -> [Experience] {
        let experiences: [ExperienceParticipant] = try await supabaseClient
            .from("Experience_Participant")
            .select()
            .eq("user_id", value: userID)
            .execute()
            .value
        
        let experienceIDs = experiences.map { $0.experienceID }
        
        if (experienceIDs.isEmpty) {
            print("Found no experiences for participant: \(userID)")
            return []
        }
        
        let final: [Experience] = try await supabaseClient
            .from("Experience")
            .select()
            .in("id", values: experienceIDs)
            .execute()
            .value
        print("Fetched \(final.count) experiences for participant: \(userID)")
        
        return final
    }
    
    func fetchAllRestaurants(for userID: String) async throws -> [Restaurant] {
        let experiences: [ExperienceParticipant] = try await supabaseClient
            .from("Experience_Participant")
            .select()
            .eq("user_id", value: userID)
            .execute()
            .value
        
        let experienceIDs = experiences.map { $0.experienceID }
        
        if (experienceIDs.isEmpty) {
            print("Found no experiences (for restaurants) for participant: \(userID)")
            return []
        }
        
        let userExperiences: [Experience] = try await supabaseClient
            .from("Experience")
            .select()
            .in("id", values: experienceIDs)
            .execute()
            .value
        
        let restaurantIDs = Array(Set(userExperiences.map { $0.restaurant_id }))

        if restaurantIDs.isEmpty {
            print("No restaurants associated with experiences for user: \(userID)")
            return []
        }

        let restaurants: [Restaurant] = try await supabaseClient
            .from("Restaurant")
            .select("id, created_at, name, address_text, avg_per_cost, details, image_url, cuisine, map_imported_rating, rating, map_imported_id")
            .in("id", values: restaurantIDs)
            .execute()
            .value

        print("Fetched \(restaurants.count) restaurants for participant: \(userID)")
        return restaurants
    }
    
    
    
//    func fetchReviews(for userID : String) async throws -> [Review] {
//        let reviews: [Review] = try await supabaseClient
//            .from("Review")
//            .select()
//            .eq("user_id", value: userID)
//            .execute()
//            .value
//        print("Fetched \(reviews.count) reviews for user \(userID)")
//        return reviews
//    }
    
    // check if username exists (NOTE: .count does not work for some reason)
    func checkUsernameExists(username: String) async throws -> Bool {
        do {
            let accountMatchingUsername : [Account] = try await supabaseClient
                .from("Account")
                .select()
                .eq("username", value: username)
                .execute()
                .value
            
            // print("numder of accounts with username \(username): \(accountMatchingUsername.count)")

            return !accountMatchingUsername.isEmpty
        } catch {
            print("Error checking username existence: \(error)")
            throw error
        }
    }
    
    func checkEmailExists(email: String) async throws -> Bool {
        do {
            let accountMatchingEmail: [Account] = try await supabaseClient
                .from("Account")
                .select("*")
                .eq("email", value: email)
                .execute()
                .value

            return !accountMatchingEmail.isEmpty
        } catch {
            print("Error checking email existence: \(error)")
            throw error
        }
    }
    
    func fetchCurrentUser() async throws -> Account {
        do {
            guard let currentUserId : UUID = supabaseClient.auth.currentUser?.id else {
                throw NSError(domain: "AccountRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "No current user found"])
            }
            return try await fetchAccount(byId: currentUserId.uuidString)
        } catch {
            print("Error fetching current user: \(error)")
            throw error
        }
    }
    

        
    
    // get Friends, both sent and received, via foreign keys
        func fetchFriends(of userId: String) async throws -> [Friends] {
            // foriegn key query
            do {
                let accountWithFriends: Account = try await supabaseClient
                    .from("Account")
                    .select(
                        """
                        id,
                        friends (
                            created_at,
                            user1_id,
                            user2_id,
                            status
                        )
                        """
                    )
                    .eq("id", value: userId)
                    .execute()
                    .value
                let friends: [Friends] = accountWithFriends.friends ?? []
                return friends
            } catch {
                print("Error fetching friends: \(error)")
                throw error
            }
        }
    
    /**
    func sendFriendRequest(from senderId: String, to receiverId: String) async throws -> Void {
        // TODO using Friends repo's method
    }
    func acceptFriendRequest(from senderId: String, to receiverId: String) async throws -> Void {
        // TODO using Friends repo's method
    }
    func rejectFriendRequest(from senderId: String, to receiverId: String) async throws -> Void {
        // TODO using Friends repo's method
    }
     */
}

