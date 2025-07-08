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
    // 1
    func createAccount(account: Account) async throws-> Void {
        do {
            try await supabaseClient
                .from("Account")
                .insert(account)
                .execute()
        } catch {
            print("Error creating user: \(error)")
            throw error
        }
    }
    
    // 2 Fetch User by username
    func getAccount(byId id: String) async throws -> Account {
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
    func getAccount(byUsername username: String) async throws -> Account {
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
    func deleteAccount(id: String) async throws-> Void {
        try? await supabaseClient
            .from("Accounts")
            .delete()
            .eq("id", value: id)
            .execute()
            .value
    }
    
    // get Friends, both sent and received
    func getFriends(of userId: String) async throws -> [Friends] {
        // foriegn key query
        do {
//            let accountWithFriends: Account = try await supabaseClient
//                .from("Account")
//                .select(
//                    """
//                    id,
//                    friends (
//                        created_at,
//                        user1_id,
//                        user2_id,
//                        status
//                    )
//                    """
//                )
//                .eq("id", value: userId)
//                .single()
//                .execute()
//                .value
//            let friends: [Friends] = accountWithFriends.friends ?? []
//            return friends
            let users: [Friends] = try await supabaseClient
                .from("Friends")
                .select()
                .eq("user1_id", value: userId)
                //.or("user2_id.eq.\(userId)")
                .execute()
                .value
            
            print("Fetched \(users.count) friends for participant: \(userId)")
            
            return users
        } catch {
            print("Error fetching friends: \(error)")
            throw error
        }
    }
        
//    func PendingFriendRequests(of userId: String) async throws -> [Friends] {
//
//    }
    
    func sendFriendRequest(from senderId: String, to receiverId: String) async throws -> Void {
        // TODO using Friends repo's method
    }
    func acceptFriendRequest(from senderId: String, to receiverId: String) async throws -> Void {
        // TODO using Friends repo's method
    }
    func rejectFriendRequest(from senderId: String, to receiverId: String) async throws -> Void {
        // TODO using Friends repo's method
    }

    // related data
    // get User's Challenges
    func getChallenges(for userId: String) async throws -> [Challenge] {
        do {
//            let accountWithChallenges: [Account] = try await supabaseClient
//                .from("Account")
//                .select(
//                    """
//                    id,
//                    challenges (*)
//                    """
//                )
//                .eq("id", value: userId)
//                .single()
//                .execute()
//                .value
//            
//            return accountWithChallenges.first?.challenges ?? []
            let challenges: [ChallengeParticipant] = try await supabaseClient
                .from("Challenge_Participant")
                .select()
                .eq("user_id", value: userId)
                .execute()
                .value
            
            let challengeIDs = challenges.map { $0.challengeID }
            
            if (challengeIDs.isEmpty) {
                print("Found no challenges for participant: \(userId)")
                return []
            }
            
            let final: [Challenge] = try await supabaseClient
                .from("Challenge")
                .select("id, title, radius, created_at, description")
                .in("id", values: challengeIDs)
                .execute()
                .value
            print("Fetched \(final.count) challenges for participant: \(userId)")
            
            return final
        } catch {
            print("Error fetching challenges: \(error)")
            throw error
        }
    }
    
    // get User's Experiences //FIXME: Not presently functional, replaced with fetchAllExperiences
    func getExperiences(for userId: String) async throws -> [Experience] {
//        do {
//            let accountWithExperiences: Account = try await supabaseClient
//                .from("Account")
//                .select(
//                    """
//                    id,
//                    Experience_Participant!user_id (
//                        Experience (*)
//                    )
//                    """
//                )
//                .eq("id", value: userId)
//                .single()
//                .execute()
//                .value
//            
//            return accountWithExperiences.experiences ?? []
//        } catch {
//            print("Error fetching experiences: \(error)")
//            throw error
//        }
        return []
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
    
    // get User's Reviews //FIXME: Not presently functional, replaced with fetchReviews
    func getReviews(by userId: String) async throws -> [Review] {
//        do {
//            
//            let accountWithReviews: Account = try await supabaseClient
//                .from("Account")
//                .select(
//                    """
//                    id,
//                    reviews (*)
//                    """
//                )
//                .eq("id", value: userId)
//                .single()
//                .execute()
//                .value
//            
//            return accountWithReviews.reviews ?? []
//        } catch {
//            print("Error fetching reviews: \(error)")
//            throw error
//        }
        return []
    }
    
    func fetchReviews(for userID : String) async throws -> [Review] {
        let reviews: [Review] = try await supabaseClient
            .from("Review")
            .select()
            .eq("user_id", value: userID)
            .execute()
            .value
        print("Fetched \(reviews.count) reviews for user \(userID)")
        return reviews
    }
    
    // check if username exists
    func checkUsernameExists(username: String) async throws -> Bool {
        do {
            let count: Int = try await supabaseClient
                .from("Account")
                .select()
                .eq("username", value: username)
                .single()
                .execute()
                .value
            return count > 0
        } catch {
            print("Error checking username existence: \(error)")
            throw error
        }
    }
        
}

