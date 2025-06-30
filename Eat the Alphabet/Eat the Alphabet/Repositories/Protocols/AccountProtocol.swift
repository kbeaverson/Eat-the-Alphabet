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
    
    // Friends
    func getFriends(of userId: String) async throws -> [Friends]
    // func getPendingFriendRequests(for userId: String) async throws -> [Account]
    
    // Friend management
    func sendFriendRequest(from senderId: String, to receiverId: String) async throws
    func acceptFriendRequest(from senderId: String, to receiverId: String) async throws
    func rejectFriendRequest(from senderId: String, to receiverId: String) async throws
    
    // Related data
    func getChallenges(for userId: String) async throws -> [Challenge]
    func getExperiences(for userId: String) async throws -> [Experience]
    func getReviews(by userId: String) async throws -> [Review]
    
    // Utilities
    func checkUsernameExists(username: String) async throws -> Bool
    
    // func searchAccounts(matching keyword: String) async throws -> [Account]
    // func blockUser(_ targetId: String, by userId: String) async throws
}
