//
//  ReviewImage.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/30.
//

struct ReviewImage: Codable {
    let reviewId: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case reviewId = "review_id"
        case imageUrl = "image_url"
    }
}
