//
//  FriendProtocal.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/7/5.
//

protocol FriendProtocol {
    // basic CRUD Operations
    func getFriendsPair(byId: String) async throws -> [Friends]// both sender and receiver
    func getFriendsPair(bySenderId: String) async throws -> [Friends] // only as sender
    func getFriendsPair(byReceiverId: String) async throws -> [Friends] // only as receiver
    func getFriendsPair(by senderId: String, receiverId: String) async throws -> Friends?
    
    // managements
    func createFriendRequest(to receiverId: String, from senderId: String) async throws -> Void
    func updateFriendRequest(to receiverId: String, from senderId: String, newStatus: String) async throws -> Void
    func deleteFriendRequest(to receiverId: String, from senderId: String) async throws -> Void // can only delete by sender
    
    // Friend management
}
