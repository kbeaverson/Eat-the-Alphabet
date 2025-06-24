//
//  ReviewViewModel.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//

import Foundation

class ReviewViewModel: ObservableObject {
    @Published var reviewText: String = ""
    @Published var ratingValue: Int = 0
    @Published var orderText: String = ""
    
    private let reviewRepository : ReviewRepository = ReviewRepository()
    
}
