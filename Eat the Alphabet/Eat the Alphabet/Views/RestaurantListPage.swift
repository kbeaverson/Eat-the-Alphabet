//
//  RestaurantListPage.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/11.
//


import SwiftUI

struct RestaurantListPage: View {
    @State private var selectedIds: Set<Int> = []

    @State private var restaurants: [RestaurantListItem] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("Challenge 01")
                    .font(.title2.bold())
                List {
                    ForEach(restaurants) { restaurant in
                        RestaurantCardView(
                            restaurant: restaurant,
                            isSelected: Binding(
                                get: { selectedIds.contains(restaurant.id) },
                                set: { isSelected in
                                    if isSelected {
                                        selectedIds.insert(restaurant.id)
                                    } else {
                                        selectedIds.remove(restaurant.id)
                                    }
                                }
                            )
                        )
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .onAppear {
                    restaurants = loadMockedRestaurants()
                }
            }
            .navigationTitle("Challenge 01")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func loadMockedRestaurants() -> [RestaurantListItem] {
        guard let url = Bundle.main.url(forResource: "restaurants", withExtension: "json") else {
            fatalError("restaurants.json not found")
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([RestaurantListItem].self, from: data)
        } catch {
            fatalError("Failed to decode restaurants.json: \(error)")
        }
    }

}

