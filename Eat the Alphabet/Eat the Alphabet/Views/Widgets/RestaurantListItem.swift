//
//  RestaurantCardView.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/11.
//

import SwiftUI
import UIKit

// the class is to be embedded inside a ExperienceListItem, as a Restaurant is a part of an Experience
struct RestaurantListItem: View {
    
    var restaurant: Restaurant
    var topPadding: CGFloat = 0
    var trailingPadding: CGFloat = 0

    @State private var loadedImage: Image? = nil
    @State private var bgColor: Color = .restaurantListItemDefault // NOTE: if not manually set, it will be the default color
    
    @StateObject private var viewModel: RestaurantViewModel = RestaurantViewModel()
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 12) {
            // image to the leftmost
            if let loadedImage = loadedImage {
                loadedImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Image("RestaurantPlaceholderImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            // stack of testaurant name, cuisine, and distance
            VStack(alignment: .leading, spacing: 4) {
                // Restaurant name, if the name is more than 20 characters, truncate it
                Text( restaurant.name.count < 20 ? restaurant.name : String(restaurant.name.prefix(20)) + "..." )
                    .font(.system(size: 24, weight: .bold, design: .serif))
                // Cuisine
                Text(restaurant.cuisine)
                    .font(.subheadline)
                // Distance, a horizontal stack of a map pin icon and distance text
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.caption)
                    Text("Distance unknown")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .foregroundColor(.defaultText) // TODO: this is font color, might need to change

            Spacer() // to push the text to the left
        }
        .background(bgColor) // changed to UIKit image average color
        .cornerRadius(12)
        .padding(.top, topPadding)
                .padding(.trailing, trailingPadding)
                .background(bgColor)
                .cornerRadius(12)
                .onAppear {
                    loadImageAndColor(from: restaurant.image_url)
                }
        
    }
    
    //TODO: load image and use UIKit's average color to set background color
    private func loadImageAndColor(from urlString: String?) {
        // guard let url = URL(string: urlString) else { return }
        guard let urlString = urlString, // NOTE: if nil, will fail, return
              !urlString.isEmpty, // NOTE: if empty, will fail, return
              let url = URL(string: urlString) else {
            return
        }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url),
                  let uiImage = UIImage(data: data) else { return }
            
            let image = Image(uiImage: uiImage)
            let averageUIColor = uiImage.averageColor ?? .restaurantListItemDefault
            let color = Color(averageUIColor)
            
            DispatchQueue.main.async {
                self.loadedImage = image
                self.bgColor = color.opacity(1.0)
            }
        }
    }
}
