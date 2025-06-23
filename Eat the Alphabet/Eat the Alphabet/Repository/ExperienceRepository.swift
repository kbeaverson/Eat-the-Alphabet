//
//  ExperienceRepository.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//


import Foundation
import SwiftUICore

class ExperienceRepository {
    func addPhoto(_ photo: Image, completion: @escaping (Result<Void, Error>) -> Void) {
        // self.photos.append(photo)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success(()))
        }
    }
    
    func removePhoto(at index: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        // self.photos.remove(at: index)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success(()))
        }
    }
    
    func addReview(_ review: Review, completion: @escaping (Result<Void, Error>) -> Void) {
        // self.reviews.append(review)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success(()))
        }
    }
    
    func addUser(_ user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        // self.users.append(user)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success(()))
        }
    }
}
