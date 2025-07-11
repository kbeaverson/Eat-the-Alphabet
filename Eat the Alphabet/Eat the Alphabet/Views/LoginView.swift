//
//  Login.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/4.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var password = ""

    // TODO: why some
    var body: some View {
        GeometryReader { geo in
            let buttonWidth = geo.size.width * 0.6
            BackgroundScaffold {
                VStack(spacing: 20) {
                    Text("Login")
                        .font(.system(size: 36, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.vertical, 40)
                    
                    TextField("Email/Phone Address", text: $email)
                        .padding(12) // inner padding (inside white box)
                        .background(.textFieldBg)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    
                    SecureField("Password", text: $password)
                        .padding(12) // inner padding (inside white box)
                        .background(.textFieldBg)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    
                    Button(action: {
                        print("Sign in pressed")
                        // TODO: replace with AuthService's varification function
//                        AuthService.shared.login(email: email, password: password) { result in
//                            switch result {
//                                case .success(let user):
//                                    print("Logged in as \(user.email ?? "unknown")")
//                                    appState.isAuthenticated = true
//                                case .failure(let error):
//                                    print("Login error: \(error.localizedDescription)")
//                                }
//                            }
                        mockLogin()
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
            }
        }
    }

    func mockLogin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            appState.isAuthenticated = true
        }
    }
}

