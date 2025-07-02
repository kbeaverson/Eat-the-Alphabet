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
    // private var appState: AppState?
    
//    public func injectAppState(appState: AppState) {
//        self.appState = appState
//        //TODO: Can uncomment the above when session persistence is implemented
//    }
    public static let shared = AuthService()

    public func login(email: String, password: String) async throws -> (Result<User, Error>) {
        do {
            let result = try await supabaseClient.auth.signIn(
                email: email,
                password: password
            )
            
            return .success(result.user)
            // appState?.session = result
        } catch {
            print("Login error: \(error)")
            return .failure(error)
        }
        // TODO: Do we need to update appState.authenticated too?
    }

    public func register(username: String, email: String, password: String) async throws -> (Result<User, Error>) {
        do {
            let result = try await supabaseClient.auth.signUp(
                email: email,
                password: password,
                data: [
                    "username": .string(username)
                ]
            )
            
            return .success(result.user)
            // appState?.session = result.session
        }
        catch {
            print("Registration error: \(error)")
            return .failure(error)
        }
    }

    public func resetPassword(email: String) async throws {
        try await supabaseClient.auth.resetPasswordForEmail(email)
        // todo: handle the email to navigate back to the app
    }

    func handleURL(_ url: URL) {
        supabaseClient.auth.handle(url)
    }

    enum AuthError: Error {
        case missingUser
    }
}
