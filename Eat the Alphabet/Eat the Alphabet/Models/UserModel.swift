//
//  UserModel.swift
//  Eat the Alphabet
//
//  Created by Will Erkman on 6/9/25.
//

import Foundation

struct User: Codable {
    let id: Int
    let created_at: String?
    let address: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case created_at
        case address
      }
}


