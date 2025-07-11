//
//  AppState.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/4.
//

import Foundation
import Supabase
import SwiftUI

class AppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
    // @Published var currentUser: User? = nil
    @Published var session: Auth.Session? = nil
}
