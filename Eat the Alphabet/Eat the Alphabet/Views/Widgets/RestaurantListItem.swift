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
    let restaurant: RestaurantViewModel
    // @Binding var isSelected: Bool // THIS now is part of the outer view
    // var isSelectionModeOn: Bool = false // THIS now is part of the outer view
    
    var onTap: (() -> Void)? = nil // for tap handling
    
    @State private var loadedImage: Image? = nil
    @State private var bgColor: Color = .restaurantListItemDefault // NOTE: if not manually set, it will be the default color
    
    var body: some View {
        /** TODO: a z-stack with the following HStack on the top and a opacity=0.5 background of same color (or default to default bg)
         and the experience on the bottom with just a title "Experience of $(experience's letter)"
         */
        
        /** TODO: if a Experience has been created (with a restaurant, and of course a letter),
         check if the user participated in the experience, if so, display the restaurant information as usual
         otherwise, display the restaurant as usual still, but with a less opacity background
         */
        /**
         TODO: Is it possible to move the long-press context menu to the entire card view.
         if User Joined: add a button to the context menu red "leave", if User Not Joined: add a button to the context menu regular "join"
         */
        /**
         TODO: Make the desciption text multilines
         */
        
        HStack {
            // image to the leftmost
            loadedImage?
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            // stack of testaurant name, cuisine, and distance
            VStack(alignment: .leading, spacing: 4) {
                // restaurant name
                Text(restaurant.name)
                    .font(.system(size: 24, weight: .bold, design: .serif))
                // cuisine
                Text(restaurant.cuisine)
                    .font(.subheadline)
                // distance, a horizontal stack of a map pin icon and distance text
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.caption)
                    // distance text
                    if let distance = restaurant.distance {
                        Text(String(format: "%.1f mile", distance * 0.621371)) // converting km to miles
                            .font(.caption)
                    } else {
                        Text("Distance unknown")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .foregroundColor(.defaultText) // TODO: this is font color, might need to change
            //.padding(.leading, 8)
            
            Spacer()
            // hide checkbox when not in selection mode
            if (isSelectionModeOn) {
                Toggle("", isOn: $isSelected)
                    .toggleStyle(CheckboxToggleStyle())
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 12)
            }
        }
        .background(bgColor) // changed to UIKit image average color
        .cornerRadius(12)
        .onAppear {
            loadImageAndColor(from: restaurant.imageUrl)
        }
        // long-press to show additional information
        .contextMenu {
            VStack(alignment: .leading) {
                Text(restaurant.details ?? "No details available")
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .padding(8)
            }
        }
        .onTapGesture {
            if !isSelectionModeOn {
                onTap?()
            }
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
