//
//  ChallengeRepository.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//

import Foundation
import CoreLocation

class ChallengeRepository {
    func addUser(_ user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        // participants.append(user)
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion(.success(())) // Simulate success
        }
    }
    
    func setTitle(_ title: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // self.title = title
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion(.success(())) // Simulate success
        }
    }
    
    func setAddress(_ address: CLLocationCoordinate2D, completion: @escaping (Result<Void, Error>) -> Void) {
        // self.address = GeoPoint(address)
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion(.success(())) // Simulate success
        }
    }
    
    func setRadius(_ radius: Float, completion: @escaping (Result<Void, Error>) -> Void) {
        // self.radius = radius
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            
            completion(.success(())) // Simulate success
        }
    }
    
    func addExperience(_ experience: Experience, completion: @escaping (Result<Void, Error>) -> Void) {
        // experiences.append(experience)
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion(.success(())) // Simulate success
        }
    }
    
    func removeLetter(_ letter: Character, completion: @escaping (Result<Void, Error>) -> Void) {
//        if let index = remainingLetters.firstIndex(of: letter) {
//            remainingLetters.remove(at: index)
//        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion(.success((()))) // Simulate success
        }
    }
}
