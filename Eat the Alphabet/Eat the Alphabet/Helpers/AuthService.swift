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
    private var appState: AppState?
    
    public static let shared = AuthService()
    
    public func injectAppState(appState: AppState) {
        self.appState = appState
        //TODO: Can uncomment the above when session persistence is implemented
    }
        

    func login(email: String, password: String) async throws {
        let result = try await supabaseClient.auth.signIn(
            email: email,
            password: password
        )
        appState?.session = result
        // TODO: Do we need to update appState.authenticated too?
    }

    func register(username: String, email: String, password: String) async throws {
        let result = try await supabaseClient.auth.signUp(
            email: email,
            password: password,
            data: [
                "username": .string(username)
            ]
        )
        appState?.session = result.session
    }

    func resetPassword(email: String) async throws {
        try await supabaseClient.auth.resetPasswordForEmail(email)
    }

    func handleURL(_ url: URL) {
        supabaseClient.auth.handle(url)
    }

    enum AuthError: Error {
        case missingUser
    }
}
