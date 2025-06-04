//
//  PasswordRestoreView.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/4.
//

import SwiftUI

struct PasswordRestoreView: View {
    @State private var email = ""
    @State private var verificationCode = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreedToTerms = false

    var body: some View {
        GeometryReader { geo in
            let fieldWidth = geo.size.width - 160
            BackgroundScaffold {
                VStack(spacing: 20) {
                    Text("Password Restore")
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
                    
                    HStack {
                        TextField("Verification Code", text: $verificationCode)
                            .padding(12) // inner padding (inside white box)
                            .background(.textFieldBg)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                        Button("Send") {
                            print("Code sent")
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    SecureField("Password", text: $password)
                        .padding(12) // inner padding (inside white box)
                        .background(.textFieldBg)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    
                    SecureField("Confirm password", text: $confirmPassword)
                        .padding(12) // inner padding (inside white box)
                        .background(.textFieldBg)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    
                    Button("Confirm") {
                        print("Restore password tapped")
                    }
                    .frame(width: fieldWidth)
                    .padding(12)
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.buttonBg)
                    )
                    .tint(.white)
                }
                .padding()
                .onAppear { print("PasswordRestoreView appeared") }
            }
        }
    }
}
