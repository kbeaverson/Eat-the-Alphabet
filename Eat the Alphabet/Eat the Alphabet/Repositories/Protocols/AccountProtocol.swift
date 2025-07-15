//
//  AccountProtocol.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/30.
//

protocol AccountProtocol {
    // CRUD
    // func createAccount(account: Account) async throws //
    func fetchAccount(byId id: String) async throws -> Account
    func updateAccount(account: Account) async throws // can only update phone, profile picture, display_name, address_wgs
    func deleteAccount(byId id: String) async throws
    
    func fetchAccount(byUsername username: String) async throws -> Account
    
    // Utilities
    func checkUsernameExists(username: String) async throws -> Bool
    func checkEmailExists(email: String) async throws -> Bool
    func fetchCurrentUser() async throws -> Account
    
    // Friends
    func getFriendsCount(of userId: String) async throws -> Int
    // func getPendingFriendRequests(for userId: String) async throws -> [Account]
    
    // Friend management (to the friend repository)
//    func sendFriendRequest(from senderId: String, to receiverId: String) async throws
//    func acceptFriendRequest(from senderId: String, to receiverId: String) async throws
//    func rejectFriendRequest(from senderId: String, to receiverId: String) async throws
    
    // get Related data, via foreign keys (only GET here)
    func fetchChallenges(for userId: String) async throws -> [Challenge]?
    func fetchExperiences(for userId: String) async throws -> [Experience]?
    func fetchReviews(for userId: String) async throws -> [Review]?
    
    func fetchAllExperiences(for userID: String) async throws -> [Experience]
    func fetchAllRestaurants(for userID: String) async throws -> [Restaurant]
    // func searchAccounts(matching keyword: String) async throws -> [Account]
    // func blockUser(_ targetId: String, by userId: String) async throws
}
