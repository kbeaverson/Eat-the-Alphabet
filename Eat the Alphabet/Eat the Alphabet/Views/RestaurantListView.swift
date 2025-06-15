//
//  RestaurantListPage.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/11.
//


import SwiftUI
import CoreLocation

struct RestaurantListView: View {
    // request permission
    @StateObject private var permissionManager = PermissionManager.shared

    //    @Environment(\.dismiss) var dismiss // ?
    //    @EnvironmentObject var appState: AppState //
    
    // passed in values: challenge Title
    @Binding var challengeTitle: String? // NOTE: if we need to change the value at list view, this is the solution
    // var challengeTitle: String? // NOTE: if not, normal value is fine
    
    // TODO: selection mode on or off
    @State private var isSelectionModeOn: Bool = false
    @State private var selectedIds: Set<String> = []
    
    // The one restaurant that actually navigated into
    @State private var selectedRestaurant: RestaurantViewModel? = nil
    
    @State private var restaurants: [RestaurantViewModel] = []
    
    var body: some View {
        GeometryReader { geo in
            BackgroundScaffold {
                ScrollView{
                    // 这个spacing是给每个item的间距
                    LazyVStack(spacing: 10) {
                        ForEach(restaurants) { restaurant in
                            RestaurantCardView(
                                restaurant: restaurant,
                                isSelected: Binding(
                                    // returns TRUE if selectedIds contaisn the restaurant id
                                    get: { selectedIds.contains(restaurant.id) },
                                    // update the selectedIds when the toggle is changed
                                    set: { isSelected in
                                        if isSelected {
                                            selectedIds.insert(restaurant.id)
                                        } else {
                                            selectedIds.remove(restaurant.id)
                                        }
                                    }
                                ),
                                isSelectionModeOn: isSelectionModeOn,
                                onTap: {
                                    selectedRestaurant = restaurant // set the
                                }
                            )
                            .listRowBackground(Color.clear) // transparent background
                            .listRowSeparator(.hidden)
                        }
                    }
                    .onAppear {
                        permissionManager.requestLocationPermission()
                        // TODO: reaplace with real pulling function
                        restaurants = loadMockedRestaurants()
                        // TODO: MOCKED database -restaurant-> Restaurant object -> RestaurantViewModel
                        let mockedRestaurant: Restaurant = Restaurant(
                            id: "999",
                            name: "Mocked Restaurant",
                            cuisine: "Mocked Cuisine",
                            price: 20,
                            rating: 4.5,
                            address: CLLocationCoordinate2D(latitude: 34.7266, longitude: 117.6279)
                        )
                        // Request location permission and get location?
                        let userLocation = permissionManager.currentLocation
                        // to RestaurantViewModel
                        let mockedRestaurantViewModel = RestaurantViewModel(restaurant: mockedRestaurant, userLocation: userLocation)
                        // append to the list
                        restaurants.append(mockedRestaurantViewModel)
                        print("Mocked restaurant added")
                    }
                    .scrollContentBackground(.hidden) // hide list background
                    .listRowSpacing(10) // remove the default padding
                    .navigationBarTitleDisplayMode(.inline)
                    .padding(10) // remove the padding
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(challengeTitle ?? "Untitled Challenge")
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .foregroundStyle(.primary)
                }
                
                // Select Done toggle (to the end)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isSelectionModeOn ? "Done" : "Select") {
                        isSelectionModeOn.toggle()
                        if !isSelectionModeOn { selectedIds.removeAll() }
                    }
                }
                
                // "Select All" shows only in selection mode
                ToolbarItem(placement: .navigationBarLeading) {
                    if isSelectionModeOn {
                        Button("Select All") {
                            // Logic to select all items
                            selectedIds = Set(restaurants.map { $0.id })
                        }
                    }
                }
            }
            .toolbarBackground(.appBackground, for: .navigationBar) // set color to toolbar
            // .toolbarBackground(.visible, for: .navigationBar) // force make the toolbar visible?
        }
        .sheet(item: $selectedRestaurant) { restaurant in
            RestaurantDetailView(restaurant: restaurant)
                .presentationDetents([.large]) // drawer-style
                .presentationDragIndicator(.visible)
        }
    }
    
    func loadMockedRestaurants() -> [RestaurantViewModel] {
        guard let url = Bundle.main.url(forResource: "fakeRestaurants", withExtension: "json") else {
            fatalError("fakeRestaurants.json not found")
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([RestaurantViewModel].self, from: data)
        } catch {
            print("❌ JSON decode error: \(error)")
            if let jsonString = String(data: try! Data(contentsOf: url), encoding: .utf8) {
                print("📄 JSON content:\n\(jsonString)")
            }
            fatalError()
        }
    }
    
}

