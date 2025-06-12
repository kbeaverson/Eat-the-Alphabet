//
//  RestaurantListPage.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/11.
//


import SwiftUI

struct RestaurantListView: View {
    @State private var selectedIds: Set<String> = []

    @State private var restaurants: [RestaurantListItem] = []

    var body: some View {
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
    
    func loadMockedRestaurants() -> [RestaurantListItem] {
        guard let url = Bundle.main.url(forResource: "fakeRestaurants", withExtension: "json") else {
            fatalError("fakeRestaurants.json not found")
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([RestaurantListItem].self, from: data)
        } catch {
            print("❌ JSON decode error: \(error)")
            if let jsonString = String(data: try! Data(contentsOf: url), encoding: .utf8) {
                print("📄 JSON content:\n\(jsonString)")
            }
            fatalError()
        }
    }

}

