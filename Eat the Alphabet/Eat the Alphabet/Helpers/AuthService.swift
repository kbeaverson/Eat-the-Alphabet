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
    
    public static let shared = AuthService()
    
    @EnvironmentObject var appState: AppState

    init(client: SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
        self.auth = client.auth
    }

    func login(email: String, password: String, completion: @escaping (Result<Account, Error>) -> Void) {
        Task {
            do {
                let result = try await auth.signIn(
                    email: email,
                    password: password
                )
                appState.session = result.self
                
                let user = result.user
                let returnedUser = Account(from: user)
                completion(.success(returnedUser))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func register(username: String, email: String, password: String, completion: @escaping (Result<Account, Error>) -> Void) {
        Task {
            do {
                let result = try await auth.signUp(
                    email: email,
                    password: password,
                    data: [
                        "username": .string(username)
                    ]
                )
                appState.session = result.session
                
                let user = result.user
                let returnedUser = Account(from: user)
                completion(.success(returnedUser))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await auth.resetPasswordForEmail(email)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func handleURL(_ url: URL) {
        auth.handle(url)
    }

    enum AuthError: Error {
        case missingUser
    }
}
