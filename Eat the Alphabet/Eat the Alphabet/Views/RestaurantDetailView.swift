//
//  RestaurantDetailView.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/14.
//

import SwiftUI

struct RestaurantDetailView: View {
    var restaurantId: String
    var restaurant: Restaurant?
    
    @StateObject private var viewModel: RestaurantViewModel = RestaurantViewModel()
    @State private var loadedImage: Image? = nil
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let loadedImage = loadedImage {
                    loadedImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 240)
                        .clipped()
                } else {
                    Image("RestaurantPlaceholderImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 240)
                        .clipped()
                }
                
                Text(viewModel.restaurant?.name ?? "")
                    .font(.system(size: 32, weight: .heavy))
                    .foregroundColor(.blue)
                    .padding(.horizontal)

                HStack {
                    Text(viewModel.restaurant?.cuisine ?? "")
                        .font(.headline)
                    Spacer()
                    Label(
                        // restaurant.distance != nil
                        false
                        ? String(format: "%.1f km", viewModel.restaurant?.address_text ?? "" /*restaurant.distance!*/)
                            : "Distance unknown",
                        systemImage: "mappin.and.ellipse")
                        .font(.caption)
                }
                .padding(.horizontal)

                HStack(spacing: 4) {
                    let rating = Int(viewModel.restaurant?.rating ?? 0)
                    // 画实心星
                    ForEach(0..<rating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    // 画空心星
                    ForEach(0..<(5 - rating), id: \.self) { _ in
                        Image(systemName: "star")
                            .foregroundColor(.gray)
                    }                }
                .padding(.horizontal)

                Text(viewModel.restaurant?.details ?? "No details available")
                    .font(.body)
                    .padding(.horizontal)

                Divider()
                    .padding(.horizontal)

//                VStack(spacing: 12) {
//                    ForEach(0..<2) { i in
//                        VStack(alignment: .leading) {
//                            HStack(spacing: 4) {
//                                ForEach(0..<5) { _ in
//                                    Image(systemName: "star")
//                                        .foregroundColor(.gray)
//                                }
//                            }
//                            Text("Alakasam")
//                                .bold()
//                            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit...")
//                                .font(.footnote)
//                        }
//                        .padding()
//                        .background(.thinMaterial)
//                        .cornerRadius(8)
//                        .padding(.horizontal)
//                    }
//                }
            }
        }
        .onAppear {
            print("passed in restaurantId: \(restaurantId)")
            print("passed in restaurant: \(String(describing: restaurant))")
            if let restaurant = restaurant {
                print("Using passed-in restaurant: \(restaurant)")
                viewModel.restaurant = restaurant
                loadImage()
            } else {
                print("Fetching restaurant with ID: \(restaurantId)")
                Task {
                    do {
                        try await viewModel.fetchRestaurant(byId: restaurantId)
                        loadImage()
                    } catch {
                        print("Error fetching restaurant: \(error)")
                    }
                }
            }
        }
    }
    
    private func loadImage() {
        // guard let url = URL(string: restaurant.imageUrl) else { return }
        guard let urlString =  viewModel.restaurant?.image_url,
            !urlString.isEmpty,
            let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let uiImage = UIImage(data: data) {
                let image = Image(uiImage: uiImage)
                DispatchQueue.main.async {
                    self.loadedImage = image
                }
            }
        }
    }
}

#Preview {
    RestaurantDetailView(restaurantId: "example-restaurant-id")
}

