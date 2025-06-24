//
//  AuthService.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/25.
//

import Supabase
import Foundation

final class AuthService {
    private let client: SupabaseClient
    private var auth: AuthClient
    
    @EnvironmentObject var appState: AppState

    init(client: SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
        self.auth = client.auth
    }

    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Task {
            do {
                let session = try await auth.signIn(email: email, password: password)
                guard let user = session.user else {
                    return completion(.failure(AuthError.missingUser))
                }
                guard let session = session.session else {
                    return completion(.failure(AuthError.missingUser))
                }
                appState.accessToken = session.accessToken
                
            } catch {
                completion(.failure(error))
            }
        }
    }

    func register(username: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Task {
            do {
                let session = try await auth.signUp(
                    email: email,
                    password: password,
                    data: [
                        "username": .string(username)
                    ]
                )
                guard let user = session.user else {
                    return completion(.failure(AuthError.missingUser))
                }
                completion(.success(user))
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
