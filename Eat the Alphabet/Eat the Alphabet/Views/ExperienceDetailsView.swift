//
//  RestaurantListPage.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/11.
//

import SwiftUI
import CoreLocation

struct ExperienceDetailsView: View {
    @EnvironmentObject var permissionManager: PermissionManager // Location permission manager
    
    // passed in values: experience letter
    let experience: Experience // PASSED IN parameter
    
    //    @State private var isSelectionModeOn: Bool = false
    //    @State private var selectedIds: Set<String> = []
    //    @State private var selectedExperience: Experience?
    
    @State private var selectedRestaurant: Restaurant? = nil
    
    @State private var cllCoord: CLLocationCoordinate2D? = nil // for location
    
    // view model info
    @StateObject private var viewModel: ExperienceViewModel = ExperienceViewModel()
    
    var body: some View {
        Group {
            if permissionManager.locationAuthorization == .authorizedWhenInUse ||
                permissionManager.locationAuthorization == .authorizedAlways {
                contentView
            } else {
                ProgressView("Requesting Location Permission...")
                    .onAppear {
                        permissionManager.requestLocationPermission()
                    }
            }
        }
    }
    
    var contentView: some View {
        GeometryReader { geo in
            BackgroundScaffold {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 10) {
                        // 上半部分：Experience 信息
                        VStack(alignment: .leading, spacing: 8) {
                            Text((experience.letter.isEmpty) ? "Experience of \(experience.letter)" : "Experience Unknown")
                                .font(.system(size: 24, weight: .bold, design: .monospaced))
                            HStack {
                                Text("Created at: \(experience.created_at.formatted(.dateTime.year().month().day().hour().minute()))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: geo.size.width * 0.9, alignment: .center)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.white).opacity(0.5)))
                        
                        // 下半部分：单个 Restaurant
                        if let restaurant = viewModel.experience?.restaurant {
                            RestaurantListItem( restaurant: restaurant )
                                .onTapGesture {
                                    selectedRestaurant = restaurant
                                }
                        }
                    }
                    .onAppear {
                        viewModel.experience = experience
                        print("Experience Details View: Experience ID: \(experience.id)")
                        if let restaurant = experience.restaurant {
                            viewModel.experience?.restaurant = restaurant
                        } else {
                            Task {
                                await viewModel.loadAssociatedRestaurant()
                            }
                        }
                    }
                }
                .padding(10)
            }
        }
        .sheet(item: $selectedRestaurant) { restaurant in
            RestaurantDetailView(
                restaurantId: viewModel.experience?.restaurant_id ?? "",
                restaurant: viewModel.experience?.restaurant,
            )
            .presentationDetents([.large]) // drawer-style
            .presentationDragIndicator(.visible)
        }
    }

}

