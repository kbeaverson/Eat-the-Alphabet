//
//  FriendRepository.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/7/6.
//

import Supabase
import Foundation

class FriendRepository : FriendProtocol {
    func getFriendsPair(byId: String) async throws -> [Friends] {
        do {
            let friendsPairs : [Friends] = try await supabaseClient
                .from("Friends")
                .select()
                .or("user1_id.eq.\(byId),user2_id.eq.\(byId)")
                .execute()
                .value
            
            return friendsPairs
        } catch {
            print("Error fetching friends pair by ID \(byId): \(error)")
            throw error
        }
    }
    
    func getFriendsPair(bySenderId: String) async throws -> [Friends] {
        do {
            let friendsPairs: [Friends] = try await supabaseClient
                .from("Friends")
                .select()
                .eq("user1_id", value: bySenderId)
                .execute()
                .value
            
            return friendsPairs
        } catch {
            print("Error fetching friends pair by sender ID \(bySenderId): \(error)")
            throw error
        }
    }
    
    func getFriendsPair(byReceiverId: String) async throws -> [Friends] {
        do {
            let friendsPairs: [Friends] = try await supabaseClient
                .from("Friends")
                .select()
                .eq("user2_id", value: byReceiverId)
                .execute()
                .value
            
            return friendsPairs
        } catch {
            print("Error fetching friends pair by receiver ID \(byReceiverId): \(error)")
            throw error
        }
    }
    
    func getFriendsPair(by senderId: String, receiverId: String) async throws -> Friends? {
        do {
            let friendsPair: Friends? = try await supabaseClient
                .from("Friends")
                .select()
                .eq("user1_id", value: senderId)
                .eq("user2_id", value: receiverId)
                .single()
                .execute()
                .value
            
            return friendsPair
        } catch {
            print("Error fetching friends pair by sender ID \(senderId) and receiver ID \(receiverId): \(error)")
            throw error
        }
    }
    
    func createFriendRequest(to receiverId: String, from senderId: String) async throws {
        do {
            let friendRequest = Friends(user1_id: senderId, user2_id: receiverId, created_at: Date(), status: "pending")
            let response = try await supabaseClient
                .from("Friends")
                .insert(friendRequest)
                .execute()
                .response
            
            if response.statusCode == 201 {
                print("Friend request created successfully.")
                return
            }
                
            print("Friend request successfully created from \(senderId) to \(receiverId).")
        } catch {
            print("Error creating friend request from \(senderId) to \(receiverId): \(error)")
            throw error
        }
    }
    
    func updateFriendRequest(to receiverId: String, from senderId: String, newStatus: String) async throws {
        do {
            let response = try await supabaseClient
                .from("Friends")
                .update(["status": newStatus])
                .eq("user1_id", value: senderId)
                .eq("user2_id", value: receiverId)
                .execute()
                .response
            
            if response.statusCode == 204 {
                print("Friend request updated successfully.")
                return
            }
        } catch {
            print("Error updating friend request from \(senderId) to \(receiverId): \(error)")
            throw error
        }
    }
    
    func deleteFriendRequest(to receiverId: String, from senderId: String) async throws {
        do {
            let response = try await supabaseClient
                .from("Friends")
                .delete()
                .eq("user1_id", value: senderId)
                .eq("user2_id", value: receiverId)
                .execute()
                .response
            
            if response.statusCode == 204 {
                print("Friend request deleted successfully.")
                return
            }
        }catch {
            print("Error deleting friend request from \(senderId) to \(receiverId): \(error)")
            throw error
        }
    }
    
    
}
    
