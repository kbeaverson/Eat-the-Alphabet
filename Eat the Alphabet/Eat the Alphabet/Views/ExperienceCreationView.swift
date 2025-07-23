//
//  ExperienceCreationView.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/7/22.
//

import SwiftUI
import CoreLocation

struct ExperienceCreationView: View {
    @State private var letter: String = ""
    @State private var restaurantId: String = ""
    @State private var challengeId: String = ""
    @State private var description: String = ""
    @State private var selectedLocation: CLLocationCoordinate2D? = nil
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil

    private let viewModel: ExperienceViewModel = ExperienceViewModel()

    var body: some View {
        GeometryReader { geo in
            let fieldWidth = geo.size.width * 0.75
            let buttonWidth = geo.size.width * 0.6
            BackgroundScaffold {
                ZStack {
                    VStack(alignment: .center, spacing: 20) {
                        Text("Create Experience")
                            .font(.system(size: 28, weight: .bold, design: .monospaced))
                            .foregroundColor(.defaultText)
                            .padding(.top)
                            .accessibilityAddTraits(.isHeader)

                        TextField("Letter", text: $letter)
                            .frame(width: fieldWidth)
                            .padding(8)
                            .background(.textFieldBg)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                            .accessibilityLabel("Experience letter field")

                        TextField("Restaurant ID", text: $restaurantId)
                            .frame(width: fieldWidth)
                            .padding(8)
                            .background(.textFieldBg)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                            .accessibilityLabel("Restaurant ID field")

                        TextField("Challenge ID", text: $challengeId)
                            .frame(width: fieldWidth)
                            .padding(8)
                            .background(.textFieldBg)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                            .accessibilityLabel("Challenge ID field")

                        Text("Description")
                            .font(.headline)
                            .fontDesign(.monospaced)
                        TextEditor(text: $description)
                            .frame(width: fieldWidth, height: 100)
                            .background(.appBackground)
                            .cornerRadius(8)
                            .accessibilityLabel("Experience description text field")

                        Text((selectedLocation != nil) ? "Selected Resaurant: \(selectedLocation?.latitude ?? 0), \(selectedLocation?.longitude ?? 0)" : "Restaurant not selected")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)

                        NavigationLink(
                            destination: MapPickerView(selectedLocation: $selectedLocation)
                        ) {
                            Text("Pick Restaurant on the Map")
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
                            createExperience()
                        }) {
                            Text("Create")
                                .font(.system(size: 18, weight: .bold, design: .monospaced))
                                .frame(maxWidth: buttonWidth)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.buttonBg)
                                )
                                .foregroundStyle(.white)
                        }.accessibilityLabel("Create experience button")
                    }
                    .padding()
                    .navigationBarTitleDisplayMode(.inline)

                    if isLoading {
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                        ProgressView("Creating Experience...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(20)
                            .background(Color.gray.opacity(0.8))
                            .cornerRadius(10)
                    }
                }
            }
        }
    }

    private func createExperience() {
        guard !letter.isEmpty, !restaurantId.isEmpty, !challengeId.isEmpty else {
            errorMessage = "请填写所有字段"
            return
        }
        isLoading = true
        let experience = Experience(
            id: UUID().uuidString,
            created_at: Date(),
            status: "incomplete",
            restaurant_id: restaurantId,
            challenge_id: challengeId,
            letter: letter
        )
        Task {
            do {
                try await viewModel.createExperience(experience: experience)
                isLoading = false
                errorMessage = nil
                // 返回上一页
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let navigationController = windowScene.windows.first?.rootViewController as? UINavigationController {
                    navigationController.popViewController(animated: true)
                }
            } catch {
                isLoading = false
                errorMessage = "创建体验失败: \(error.localizedDescription)"
            }
        }
    }
}
