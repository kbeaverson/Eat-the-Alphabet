//
//  UserViewModel.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//

import Foundation
import CoreLocation
import Supabase

class AccountViewModel: ObservableObject {
    @Published var user: Account
    private let repository: AccountRepository
    
    init() {
        self.user = Account(
            id: UUID().uuidString,
            created_at: Date(),
            address_wgs: GeoPoint(CLLocationCoordinate2D(latitude: 0, longitude: 0)),
            username: "",
            display_name: "",
            profile_image_url: nil,
            phone_number: nil,
            email: "" // This should be set to the authenticated user's email later
        )
        self.repository = AccountRepository()
        }

}

