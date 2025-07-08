//
//  Login.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/4.
//

import SwiftUI
import Supabase

struct LoginView : View {
    @Binding var session: Session?
    // @EnvironmentObject var appState: AppState
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    
    // TODO: why some
    var body: some View {
        GeometryReader { geo in
            let buttonWidth = geo.size.width * 0.6
            BackgroundScaffold {
                ZStack {
                    VStack(spacing: 20) {
                        Text("Login")
                            .font(.system(size: 36, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .padding(.vertical, 40)
                        
                        TextField("Email/Phone Address", text: $email)
                            .textContentType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding(12) // inner padding (inside white box)
                            .background(.textFieldBg)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                        
                        SecureField("Password", text: $password)
                            .textContentType(.password)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding(12) // inner padding (inside white box)
                            .background(.textFieldBg)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                        
                        if let errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.top, 10)
                        }
                        
                        Button(action: {
                            print("Sign in pressed")
                            login()
                        }) {
                            Text("Sign in")
                                .font(.system(size: 18, weight: .bold, design: .monospaced))
                                .frame(width: buttonWidth, height: 46)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.buttonBg)
                                )
                                .foregroundStyle(.white)
                        }
                        
                        
                        NavigationLink(destination: RegisterView()) {
                            Text("Register")
                                .font(.system(size: 18, weight: .bold, design: .monospaced))
                                .frame(width: buttonWidth, height: 46)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.buttonBg)
                                )
                                .foregroundStyle(.white)
                        }
                        
                        
                        NavigationLink("Restore Password", destination: PasswordRestoreView())
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 40)
                    .onAppear { print("LoginView appeared") }
                    .onDisappear{ print("LoginView disappeared") }
                    
                    // Floating overlay for loading state
                    if isLoading {
                        // a dimmed background
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                        
                        // the little "window"
                        VStack(spacing: 12) {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .scaleEffect(1.5)
                            
                            Text("Signing In…")
                                .font(.subheadline)
                                .bold()
                        }
                        .padding(24)
                        .background(.ultraThinMaterial) // Note: aethetically beautiful blurred background
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .transition(.opacity)
                    }
                }
            }
            .animation(.easeInOut, value: isLoading) // animate the loading overlay
        }
    }
    private func login() {
        Task {
            // make sure view-driving states changes are made on the main thread
            await MainActor.run {
                isLoading = true
                errorMessage = nil
            }
            
            do {
                let result = try await AuthService.shared.login(email: email, password: password)
                switch result {
                case .success(let user):
                    let newSession = try await supabaseClient.auth.session
                    await MainActor.run {
                        // appState.currentAuthUser = user
                        self.session = newSession
                    }
                case .failure(let error):
                    await MainActor.run {
                        errorMessage = "Login failed: \(error.localizedDescription)"
                    }
                }
            }
            catch {
                await MainActor.run {
                    errorMessage = "Login error: \(error.localizedDescription)"
                }
            }
            await MainActor.run {
                isLoading = false
            }
        }
    }
    /** end of login() function */
    
}

#Preview {
    LoginView(session: .constant(nil))
}
        
