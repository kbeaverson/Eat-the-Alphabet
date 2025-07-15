//
//  AccountRepoTests.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/7/11.
//

import Foundation
import XCTest
@testable import Eat_the_Alphabet
import Supabase

final class AccountRepoTests: XCTestCase {
    let repo = AccountRepository()
    
    
    let testUserId = "74ab959f-ad2c-40f3-b1b2-0cc84341c5ca"
    let testUsername = "Frederisch L"
    let testEmail = "luxiliao@iu.edu"
    let testPhone = "18345678901"
    let testDisplayName = "Ludwig van Beethoven"
    let testProfileImage = "https://cf-assets.www.cloudflare.com/zkvhlag99gkb/45BaEMmPeM13adYBN7nanP/eaceb4f50062eaf53c4a484231f177ee/image12-1.png"
    let testAddress = "POINT(121.4737 31.2304)" // Shanghai coordinates
    
    func testFetchAccount() async throws {
        do {
            let account = try await repo.fetchAccount(byId: testUserId)
            
            print("Fetched account: \(account)")
            XCTAssertEqual(account.id, testUserId)
        } catch {
            XCTFail("Failed to fetch account: \(error)")
            throw error
        }
    }
    
    func testUpdateAccount() async throws { // 
        do {
            var account  = try await repo.fetchAccount(byId: testUserId)
            account.phone_number = testPhone
            try await repo.updateAccount(account: account)
            let updatedAccount = try await repo.fetchAccount(byId: testUserId)
            XCTAssertEqual(updatedAccount.phone_number, testPhone, "Phone number should be updated")
            
        } catch {
            XCTFail("Failed to update account: \(error)")
            throw error
        }
    }

//    func deleteAccount() async throws {
//        do {
//            // try await repo.deleteAccount(byId: testUserId)
//            print("Account deleted successfully")
//        } catch {
//            XCTFail("Failed to delete account: \(error)")
//            throw error
//        }
//    }
    
    func testFetchAccountByUsername() async throws {
        do {
            let account = try await repo.fetchAccount(byUsername: testUsername)
            print("Fetched account by username: \(account)")
        } catch {
            XCTFail("Failed to fetch account by username: \(error)")
            throw error
        }
    }
        
    func testCheckUsernameExists() async throws {
        do {
            let exists = try await repo.checkUsernameExists(username: testUsername)
            XCTAssertTrue(exists, "Username should exist")
        } catch {
            XCTFail("Failed to check if username exists: \(error)")
            throw error
        }
    }
    
    func testCheckEmailExists() async throws {
        do {
            let exists = try await repo.checkEmailExists(email: testEmail)
            XCTAssertTrue(exists, "Email should exist")
        }
        catch {
            XCTFail("Failed to check if email exists: \(error)")
            throw error
        }
    }
    
    func testFetchCurrentUser() async throws {
        do {
            let user = try await repo.fetchCurrentUser()
            XCTAssertNotNil(user, "Current user should not be nil")
            let currentUserId = supabaseClient.auth.currentUser?.id.uuidString ?? ""
            print("Current user ID: \(currentUserId), Fetched user ID: \(user.id)")
            if currentUserId == "" {XCTFail("Current user ID should not be nil")}
            // FIXME: the current is uppercased, the remote is lowercased
            XCTAssertEqual(user.id.lowercased(), currentUserId.lowercased(), "Current user ID should match the authenticated user ID")
        }
        catch {
            XCTFail("Failed to get current user: \(error)")
        }
    }
        
    // func get number of friends
    func getFriendsCount() async throws {
//        do {
//            let count = try await repo.getFriendsCount()
//            XCTAssertGreaterThan(count, 0, "Friends count should be greater than 0")
//        } catch {
//            XCTFail("Failed to get friends count: \(error)")
//            throw error
//        }
    }
    
    
    func testFetchChallenges() async throws {
        do {
            let challenges : [Challenge]? = try await repo.fetchChallenges(for: testUserId)
            //for challenge in challenges ?? [] {
            //    print("Fetched challenge: \(challenge.id)")
            //}
            XCTAssertNotNil(challenges, "Challenges should not be nil")
        }
        catch {
            XCTFail("Failed to fetch challenges: \(error)")
            throw error
        }
    }
    
    func testFetchExperiences() async throws {
        do {
            let experiences : [ Experience ]? = try await repo.fetchExperiences(for: testUserId)
            for experience in experiences ?? [] {
                print("Fetched experience: \(experience.id)")
            }
            XCTAssertNotNil(experiences, "Experiences should not be nil")
        } catch {
            XCTFail("Failed to fetch experiences: \(error)")
            throw error
        }
    }
    
    
//    func testFetchRestaurants() async throws {
//        do {
//            let restaurants = try await repo.fetchRestaurants(for: testUserId)
//            XCTAssertNotNil(restaurants, "Restaurants should not be nil")
//        } catch {
//            XCTFail("Failed to fetch restaurants: \(error)")
//            throw error
//        }
//    }
    
    func testFetchReviews() async throws {
        do {
            let reviews = try await repo.fetchReviews(for: testUserId)
            for review in reviews ?? [] {
                print("Fetched review: \(review.id)")
            }
            XCTAssertNotNil(reviews, "Reviews should not be nil")
        } catch {
            XCTFail("Failed to fetch reviews: \(error)")
            throw error
        }
    }
}
    

