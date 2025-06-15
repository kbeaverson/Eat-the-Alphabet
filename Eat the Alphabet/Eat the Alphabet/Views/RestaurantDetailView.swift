//
//  RestaurantDetailView.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/14.
//

import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: RestaurantViewModel
    @State private var loadedImage: Image? = nil
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                loadedImage?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 240)
                    .clipped()

                Text(restaurant.name)
                    .font(.system(size: 32, weight: .heavy))
                    .foregroundColor(.blue)
                    .padding(.horizontal)

                HStack {
                    Text(restaurant.cuisine)
                        .font(.headline)
                    Spacer()
                    Label(
                        restaurant.distance != nil
                            ? String(format: "%.1f km", restaurant.distance!)
                            : "Distance unknown",
                        systemImage: "mappin.and.ellipse")
                        .font(.caption)
                }
                .padding(.horizontal)

                HStack(spacing: 4) {
                    ForEach(0..<5) { i in
                        Image(systemName: i < 4 ? "star.fill" : "star") // Example: 4/5 stars
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)

                Text(restaurant.details ?? "No details available")
                    .font(.body)
                    .padding(.horizontal)

                Divider()
                    .padding(.horizontal)

                VStack(spacing: 12) {
                    ForEach(0..<2) { i in
                        VStack(alignment: .leading) {
                            HStack(spacing: 4) {
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star")
                                        .foregroundColor(.gray)
                                }
                            }
                            Text("Alakasam")
                                .bold()
                            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit...")
                                .font(.footnote)
                        }
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                }
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        // guard let url = URL(string: restaurant.imageUrl) else { return }
        guard let urlString =  restaurant.imageUrl,
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
