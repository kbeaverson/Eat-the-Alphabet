//
//  ChallengeCreationView.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/7/8.
//

import SwiftUI
import CoreLocation

struct ChallengeCreationView: View {
    @State private var title: String = ""
    @State private var radius: String = ""
    @State private var description: String = ""
    @State private var selectedLocation: CLLocationCoordinate2D? = nil
    @State private var showMapPicker: Bool = false
    
    private let viewModel: ChallengeViewModel = ChallengeViewModel(
        challenge: Challenge(
            id: UUID().uuidString,
            title: "",
            center_wgs: "POINT(0 0)",
            radius: 0.0,
            created_at: Date(),
            description: ""
        )
            
    )
    @State private var errorMessage: String? = nil
    
    var body: some View {
        GeometryReader { geo in
            let fieldWidth = geo.size.width * 0.75
            let buttonWidth = geo.size.width * 0.6
            BackgroundScaffold {
                VStack(alignment: .center, spacing: 20) {
                    Text("Create Challenge")
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .foregroundColor(.defaultText)
                        .padding(.top)
                    
                    TextField("Challenge Title", text: $title)
                        .frame(width: fieldWidth)
                        .padding(8)
                        .background(.textFieldBg)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    
                    TextField("Radius", text: $radius)
                        .frame(width: fieldWidth)
                        .keyboardType(.numberPad)
                        .padding(8)
                        .background(.textFieldBg)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    // .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Description")
                        .font(.headline)
                        .fontDesign(.monospaced)
                    TextEditor(text: $description)
                        .frame(width: fieldWidth, height: 100)
                        .background(.appBackground)
                        .cornerRadius(8)
                    
                    // location lext
                    Text((selectedLocation != nil) ? "Selected Location: \(selectedLocation?.latitude ?? 0), \(selectedLocation?.longitude ?? 0)" : "No location selected")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                    
                    NavigationLink(
                        destination: MapPickerView(selectedLocation: $selectedLocation),
                    ) {
                        Text("Pick Point on Map")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .frame(maxWidth: buttonWidth)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.defaultText)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundStyle(.defaultText)
                    .frame(width: fieldWidth)
                    
                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // 创建挑战逻辑
                        createChallenge()
                    }) {
                        Text("Create Challenge")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .frame(maxWidth: buttonWidth)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.buttonBg)
                            )
                            .foregroundStyle(.white)
                    }
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    private func createChallenge() {
        // Validate inputs
        guard !title.isEmpty, !radius.isEmpty, let selectedLocation = selectedLocation else {
            print("Please fill in all fields.")
            errorMessage = "Please fill in all fields."
            return
        }
        
        // Convert radius to Float
        guard let radius = Float(radius), radius > 0 else {
            print("Invalid radius value.")
            errorMessage = "Invalid radius value."
            return
        }
        
        /** center_wgs in format POINT(--- ---) */
        viewModel.challenge = Challenge(
            id: UUID().uuidString, // Generate a new UUID for the challenge
            title: title,
            center_wgs: String(format: "POINT(%f %f)", selectedLocation.longitude, selectedLocation.latitude),
            radius: Float(radius),
            created_at: Date(),
            description: description,
        )
        Task {
            do {
                try await viewModel.createChallenge()
            } catch {
                print("Error creating challenge: \(error.localizedDescription)")
                errorMessage = "Error creating challenge: \(error.localizedDescription)"
                return
            }
            do {
                try await viewModel.joinChallenge(userId: supabaseClient.auth.user().id.uuidString, challengeId: viewModel.challenge.id)
                print("Challenge created and joined successfully.")
            } catch {
                print("Challenge created, but failed to join: \(error.localizedDescription)")
                errorMessage = "Challenge created, but failed to join: \(error.localizedDescription)"
            }
        }
    }
}
