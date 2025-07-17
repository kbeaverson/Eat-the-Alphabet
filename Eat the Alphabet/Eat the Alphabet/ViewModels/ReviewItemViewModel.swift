//
//  ReviewViewModel.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//

import Foundation

class ReviewItemViewModel: ObservableObject {
    @Published var review: Review
    private let reviewRepository : ReviewRepository /*= ReviewRepository()*/
    
    init(review: Review) {
        self.review = review
        self.reviewRepository = ReviewRepository()
    }
    
    //
//    func createReview() async {
//        do {
//            try await reviewRepository.createReview(review: review)
//        } catch {
//            print("Error creating review: \(error)")
//        }
//    }
    
    // NOTE: one can only delete his/her own review
//    func deleteReview() async {
//        do {
//            try await reviewRepository.deleteReview(review: review)
//        } catch {
//            print("Error deleting review: \(error)")
//        }
//    }
    
    func updateReviewText(reviewText: String) async {
        review.review = reviewText
        review = review
        do {
            try await reviewRepository.updateReview(review: review, userId: supabaseClient.auth.currentUser?.id.uuidString ?? "")
        } catch {
            print("Error updating review text: \(error)")
        }
    }
    
    func updateReviewRating(rating: Int) async {
        review.rating = rating
        review = review
        do {
            try await reviewRepository.updateReview(review: self.review, userId: supabaseClient.auth.currentUser?.id.uuidString ?? "")
        } catch {
            print("Error updating review rating: \(error)")
        }
    }
    
    func updateReviewOrder(order: String) async {
        review.order = order
        review = review
        do {
            try await reviewRepository.updateReview(review: self.review, userId: supabaseClient.auth.currentUser?.id.uuidString ?? "")
        } catch {
            print("Error updating review order: \(error)")
        }
    }
}
