//
//  MockAuthService.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/5.
//

// helper function for supabase authentication
import Supabase
import Foundation

final class AuthService {
    static let shared = AuthService()

    private let client = SupabaseClient(
        supabaseURL: URL(string: "***.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5xYmNjanNzYXR1c2x3Y2N6YmtkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwMDQzMzMsImV4cCI6MjA2NDU4MDMzM30.Aeo3cmi9K48Csiw0zmlBcErItpXxQq0Cphisx_WC0Sc"
    )

    private init() {}

    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Task {
            do {
                let session = try await client.auth.signIn(email: email, password: password)
                completion(.success(session.user))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func register(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Task {
            do {
                let session = try await client.auth.signUp(email: email, password: password)
                completion(.success(session.user))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await client.auth.resetPasswordForEmail(email)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
