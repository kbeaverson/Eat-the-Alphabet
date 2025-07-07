//
//  AccountProtocol.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/30.
//

protocol AccountProtocol {
    // CRUD
    func createAccount(account: Account) async throws //
    func getAccount(byId id: String) async throws -> Account
    func getAccount(byUsername username: String) async throws -> Account
    func updateAccount(account: Account) async throws
    func deleteAccount(id: String) async throws
    
    // Utilities
    func checkUsernameExists(username: String) async throws -> Bool
    func checkEmailExists(email: String) async throws -> Bool
    func getCurrentUser() async throws -> Account
    
    // Friends
    func getFriendsCount(of userId: String) async throws -> Int
    // func getPendingFriendRequests(for userId: String) async throws -> [Account]
    
    // Friend management (to the friend repository)
//    func sendFriendRequest(from senderId: String, to receiverId: String) async throws
//    func acceptFriendRequest(from senderId: String, to receiverId: String) async throws
//    func rejectFriendRequest(from senderId: String, to receiverId: String) async throws
    
    // get Related data, via foreign keys (only GET here)
    func getChallenges(for userId: String) async throws -> [Challenge]
    func getExperiences(for userId: String) async throws -> [Experience]
    func getReviews(by userId: String) async throws -> [Review]
    
    // func searchAccounts(matching keyword: String) async throws -> [Account]
    // func blockUser(_ targetId: String, by userId: String) async throws
}
