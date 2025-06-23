//
//  ReviewRepository.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//

import Foundation

class ReviewRepository {
    
    func addReview(reviewText : String, completion: @escaping (Result<Void, Error>) -> Void) {
        // review = reviewText;
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success(()))
        }
    }
    
    func addRating(ratingValue : Int, completion: @escaping (Result<Void, Error>) -> Void) {
//        rating = ratingValue;
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            completion(.success(()))
        }
    }
    
    func addOrder(orderText : String, completion: @escaping (Result<Void, Error>) -> Void) {
//        order = orderText;
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success(()))
        }
    }
}
