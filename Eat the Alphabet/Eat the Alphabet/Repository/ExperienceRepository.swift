//
//  ExperienceRepository.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//


import Foundation
import SwiftUICore

class ExperienceRepository {
    func createExperience(experience : Experience, completion: @escaping (Result<String, Error>) -> Void) {
        // FIXME: Create new experience in supabase
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion(.success((""))) // Simulate success
        }
    }
    
    // FIXME: Return [Challenge]
    func fetchAllExperiences(user : User, completion: @escaping (Result<String, Error>) -> Void) {
        // FIXME: Get list of all experiences for a given user
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion(.success((""))) // Simulate success
        }
    }
    
    func updateExperience(expereience : Experience, completion: @escaping (Result<String, Error>) -> Void) {
        // FIXME: Update experience with corresponding id in supabase
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion(.success((""))) // Simulate success
        }
    }
    
    func deleteExperience(experience : Experience, completion: @escaping (Result<String, Error>) -> Void) {
        // FIXME: Delete experience with corresponding id from supabase
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion(.success((""))) // Simulate success
        }
    }
}
