//
//  review.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/9/25.
//

import Foundation

class Review {
    let user : User
    let id : Int
    var date : Date
    var review : String
    var rating : Int
    var order : String
    
    init(user: User, id: Int, date: Date, review: String, rating: Int, order: String) {
        self.user = user
        self.id = id
        self.date = date
        self.review = review
        self.rating = rating
        self.order = order
    }
    
    func addReview(reviewText : String) {
        review = reviewText;
    }
    
    func addRating(ratingValue : Int) {
        rating = ratingValue;
    }
    
    func addOrder(orderText : String) {
        order = orderText;
    }
}
