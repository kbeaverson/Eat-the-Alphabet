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

    var body: some View {
        GeometryReader { geo in
            let fieldWidth = geo.size.width - 160
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
                    
                    Button("Sign in") {
                        AuthService.shared.login(email: email, password: password) { result in
                            switch result {
                            case .success(let user):
                                print("Logged in as \(user.email ?? "unknown")")
                                appState.isAuthenticated = true
                            case .failure(let error):
                                print("Login error: \(error.localizedDescription)")
                            }
                        }
                    }
                        .frame(width: fieldWidth)
                        .padding(12)
                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.buttonBg)
                        )
                        .tint(.white)
                    
                    NavigationLink("Register", destination: RegisterView())
                        .frame(width: fieldWidth)
                        .padding(12)
                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                        .cornerRadius(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.buttonBg)
                        )
                        .tint(.white)
                    
                    NavigationLink("Restore Password", destination: PasswordRestoreView())
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 40)
                .onAppear { print("LoginView appeared") }
            }
        }
    }

//    func mockLogin() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            appState.isAuthenticated = true
//        }
//    }
}

