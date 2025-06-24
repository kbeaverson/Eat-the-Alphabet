//
//  ChallengeRepository.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//

import Foundation
import CoreLocation

class ChallengeRepository {
    func createChallenge(challenge : Challenge, completion: @escaping (Result<String, Error>) -> Void) {
        // FIXME: Create new challenge in supabase
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion(.success((""))) // Simulate success
        }
    }
    
    // FIXME: Return [Challenge]
    func fetchAllChallenges(user : User, completion: @escaping (Result<String, Error>) -> Void) {
        // FIXME: Get list of all challenges for a given user
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion(.success((""))) // Simulate success
        }
    }
    
    func updateChallenge(challenge : Challenge, completion: @escaping (Result<String, Error>) -> Void) {
        // FIXME: Update challenge with corresponding id in supabase
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion(.success((""))) // Simulate success
        }
    }
    
    func deleteChallenge(challenge : Challenge, completion: @escaping (Result<String, Error>) -> Void) {
        // FIXME: Delete challenge with corresponding id from supabase
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion(.success((""))) // Simulate success
        }
    }
}
