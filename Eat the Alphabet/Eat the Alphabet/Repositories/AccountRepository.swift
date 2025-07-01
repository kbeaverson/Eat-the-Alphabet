//
//  UserRepository.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//

import Foundation
import Supabase

class AccountRepository : AccountProtocol {
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
                .select()
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
                .single()
                .execute()
                .value
            let friends: [Friends] = accountWithFriends.friends ?? []
            return friends
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
            let accountWithChallenges: [Account] = try await supabaseClient
                .from("Account")
                .select(
                    """
                    id,
                    challenges (*)
                    """
                )
                .eq("id", value: userId)
                .single()
                .execute()
                .value
            
            return accountWithChallenges.first?.challenges ?? []
        } catch {
            print("Error fetching challenges: \(error)")
            throw error
        }
    }
    
    // get User's Experiences
    func getExperiences(for userId: String) async throws -> [Experience] {
        do {
            let accountWithExperiences: [Account] = try await supabaseClient
                .from("Account")
                .select(
                    """
                    id,
                    experiences (*)
                    """
                )
                .eq("id", value: userId)
                .single()
                .execute()
                .value
            
            return accountWithExperiences.first?.experiences ?? []
        } catch {
            print("Error fetching experiences: \(error)")
            throw error
        }
    }
    
    // get User's Reviews
    func getReviews(by userId: String) async throws -> [Review] {
        do {
            
            let accountWithReviews: [Account] = try await supabaseClient
                .from("Account")
                .select(
                    """
                    id,
                    reviews (*)
                    """
                )
                .eq("id", value: userId)
                .single()
                .execute()
                .value
            
            return accountWithReviews.first?.reviews ?? []
        } catch {
            print("Error fetching reviews: \(error)")
            throw error
        }
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

