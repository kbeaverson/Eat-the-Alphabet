//
//  RestaurantCardView.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/11.
//

import SwiftUI
import UIKit

struct RestaurantListItem: Identifiable, Decodable {
    let id: String
    let name: String
    let cuisine: String
    let distance: String
    let imageUrl: String
    let details: String
    // TODO: image color
}

struct RestaurantCardView: View {
    let restaurant: RestaurantListItem
    @Binding var isSelected: Bool
    
    @State private var loadedImage: Image? = nil
    @State private var bgColor: Color = .restaurantListItemDefault
    
    var body: some View {
        HStack {
            loadedImage?
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.leading, 8)

            VStack(alignment: .leading, spacing: 4) {
                Text(restaurant.name)
                    .font(.system(size: 20, weight: .bold, design: .serif))
                Text(restaurant.cuisine)
                    .font(.subheadline)
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.caption)
                    Text(restaurant.distance)
                        .font(.caption)
                }
            }
            .foregroundColor(.secondary) // TODO: this is font color, might need to change
            .padding(.leading, 8)

            Spacer()

            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.trailing, 12)
        }
        .padding(.vertical, 8)
        .background(bgColor) // TODO: change to UIKit image average color
        .cornerRadius(12)
        // TODO: long-press to show more information
        .contextMenu {
            VStack(alignment: .leading) {
                Text(restaurant.name)
                    .font(.title2.bold())
                Text(restaurant.cuisine)
                    .font(.subheadline)
                Text("📍 \(restaurant.distance)")
                    .font(.footnote)
                Divider()
                Text(restaurant.details)
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
            }
            .padding()
        }
        .padding(.horizontal)
        .onAppear {
            loadImageAndColor(from: restaurant.imageUrl)
        }
    }
    
    //TODO: load image and use UIKit's average color to set background color
    private func loadImageAndColor(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url),
                  let uiImage = UIImage(data: data) else { return }
            
            let image = Image(uiImage: uiImage)
            let averageUIColor = uiImage.averageColor ?? .restaurantListItemDefault
            let color = Color(averageUIColor)
            
            DispatchQueue.main.async {
                self.loadedImage = image
                self.bgColor = color.opacity(0.15)
            }
        }
    }
}
