//
//  AuthService.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/25.
//

import Supabase
import Foundation
import SwiftUI

final class AuthService {
    private let client: SupabaseClient
    private var auth: AuthClient
    private var appState: AppState?
    
    public static let shared = AuthService()

    init(client: SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
        self.auth = client.auth
    }
    
    public func injectAppState(appState: AppState) {
        self.appState = appState
        
//        if let session = SupabaseManager.shared.client.auth.session {
//                appState.session = session
//                appState.isAuthenticated = true
//        }
        //TODO: Can uncomment the above when session persistence is implemented
    }
        

    func login(email: String, password: String) async throws {
        let result = try await auth.signIn(
            email: email,
            password: password
        )
        appState?.session = result.self
        // TODO: Do we need to update appState.authenticated too?
    }

    func register(username: String, email: String, password: String) async throws {
        let result = try await auth.signUp(
            email: email,
            password: password,
            data: [
                "username": .string(username)
            ]
        )
        appState?.session = result.session
    }

    func resetPassword(email: String) async throws {
        try await auth.resetPasswordForEmail(email)
    }

    func handleURL(_ url: URL) {
        auth.handle(url)
    }

    enum AuthError: Error {
        case missingUser
    }
}
