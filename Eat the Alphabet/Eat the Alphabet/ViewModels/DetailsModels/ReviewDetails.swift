//
//  ReviewDetails.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/30.
//

import Foundation

struct ReviewDetails: Identifiable, Codable {
    // the review itself
    let id: String
    let created_at: Date
    var title: String?
    var review: String
    var rating: Int
    var order: String?
    
    // review table has foreign key to user table
    let user: Account
    // review table has foreign key to experience table
    let experience: Experience
}
