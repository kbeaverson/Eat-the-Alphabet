//
//  ExperienceCreationView.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/7/22.
//

import SwiftUI
import CoreLocation

struct ExperienceCreationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var letter: String = ""
    @State private var restaurantId: String = ""
    @State private var description: String = ""
    
    @State private var restaurantCuisine: String = ""
    
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    @State var restaurant: Restaurant? = nil
    var challengeCenter: CLLocationCoordinate2D
    var challengeId: String
    
    let domesticCuisines: [String] = [
        "American",
        "Southern",
        "Soul Food",
        "Cajun",
        "Creole",
        "Tex-Mex",
        "Barbecue",
        "New American"
    ]
    
    let internationalCuisines: [String] = [
        "Italian",
        "Mexican",
        "Chinese",
        "Japanese",
        "Thai",
        "Indian",
        "Vietnamese",
        "Greek",
        "Mediterranean",
        "Korean",
        "Middle Eastern",
        "French"]
    
    let otherCuisines: [String] = [
        "Ethiopian",
        "Caribbean",
        "Peruvian",
        "Brazilian",
        "Filipino"
    ]


    private let viewModel: ExperienceViewModel = ExperienceViewModel()
    private let restaurantRepository: RestaurantRepository = RestaurantRepository()

    var body: some View {
        GeometryReader { geo in
            let fieldWidth = geo.size.width * 0.75
            let buttonWidth = geo.size.width * 0.6
            BackgroundScaffold {
                ZStack {
                    ScrollView(.vertical, showsIndicators: false) {
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
                            
                            Text("Challenge Center WGS84: \(challengeCenter.latitude), \(challengeCenter.longitude)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.top, 8)
                            
                            NavigationLink(
                                destination: MapView(challengeCenter: challengeCenter, restaurant: Binding(
                                    get: { restaurant },
                                    set: { restaurant = $0 }
                                ))
                            ) {
                                Text("Open Full Map")
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
                            
                            if restaurant == nil {
                                TextField("Alternatively: Restaurant ID", text: $restaurantId)
                                    .frame(width: fieldWidth)
                                    .padding(8)
                                    .background(.textFieldBg)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                    )
                            } else {
                                // drop down menu here
                                Menu {
                                    Picker("Select Cuisine", selection: $restaurantCuisine) {
                                        Section(header: Text("American")) {
                                            ForEach(domesticCuisines, id: \.self) { cuisine in
                                                Text(cuisine).tag(cuisine)
                                            }
                                        }
                                        Section(header: Text("International")) {
                                            ForEach(internationalCuisines, id: \.self) { cuisine in
                                                Text(cuisine).tag(cuisine)
                                            }
                                        }
                                        Section(header: Text("Others")) {
                                            ForEach(otherCuisines, id: \.self) { cuisine in
                                                Text(cuisine).tag(cuisine)
                                            }
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(restaurantCuisine.isEmpty ? "Select Cuisine" : "Selected：\(restaurantCuisine)")
                                        Image(systemName: "chevron.down")
                                    }
                                }
                                .frame(maxWidth: buttonWidth)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                
                                // 确认按钮
                                Button(action: {
                                    // more advanced logic can be added here. Adding cuisine type to the restaurant object.
                                    restaurant?.cuisine = restaurantCuisine
                                    // update the restaurant object in the view model
                                    if let restaurant = restaurant {
                                        Task {
                                            do {
                                                try await restaurantRepository.updateRestaurant(restaurant: restaurant)
                                            } catch {
                                                errorMessage = "Failed to update restaurant: \(error.localizedDescription)"
                                            }
                                        }
                                    }
                                }) {
                                    Text("Confirm Cuisine")
                                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                                        .frame(maxWidth: buttonWidth)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.green.opacity(0.2))
                                        )
                                        .foregroundStyle(.defaultText)
                                        .cornerRadius(12)
                                }
                                
                                Button(action: {
                                    restaurant = nil
                                }) {
                                    Text("Clear Selected Restaurant")
                                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                                        .frame(maxWidth: buttonWidth)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.red.opacity(0.1))
                                        )
                                        .foregroundStyle(.defaultText)
                                        .cornerRadius(12)
                                }
                            }
                            
                            Text("Description")
                                .font(.headline)
                                .fontDesign(.monospaced)
                            TextEditor(text: $description)
                                .frame(width: fieldWidth, height: 100)
                                .background(.appBackground)
                                .cornerRadius(8)
                            
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
                    }

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
        guard !letter.isEmpty, restaurant != nil ? true : !restaurantId.isEmpty, !challengeId.isEmpty else {
            errorMessage = "Please fill in all the required fields."
            return
        }
        isLoading = true
        let experience = Experience(
            id: UUID().uuidString,
            created_at: Date(),
            status: "incomplete",
            restaurant_id: restaurant?.id ?? restaurantId,
            challenge_id: challengeId,
            letter: letter.uppercased()
        )
        Task {
            do {
                try await viewModel.createExperience(experience: experience)
                isLoading = false
                errorMessage = nil
            } catch {
                isLoading = false
                errorMessage = "Creation Failed: \(error.localizedDescription)"
            }
            dismiss()
        }
    }
}
