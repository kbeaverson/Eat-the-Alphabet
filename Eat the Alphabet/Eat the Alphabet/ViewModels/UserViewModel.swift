//
//  UserViewModel.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//

import Foundation
import CoreLocation
import Supabase

class UserViewModel: ObservableObject {
    @Published var user: User
    private let repository: UserRepository
    
    init(
        user: User = User(
            id: UUID().uuidString,
            created_at: Date(),
            address: GeoPoint(CLLocationCoordinate2D(latitude: 0, longitude: 0)),
        ), repository: UserRepository = UserRepository()) {
            self.repository = repository
            self.user = user
        }

    
    private let userRepository = UserRepository.shared
    

}

