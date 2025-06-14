//
//  RestaurantCardView.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/11.
//

import SwiftUI
import UIKit

struct RestaurantCardView: View {
    let restaurant: RestaurantViewModel
    @Binding var isSelected: Bool
    var isSelectionModeOn: Bool = false
    
    var onTap: (() -> Void)? = nil // for tap handling
    
    @State private var loadedImage: Image? = nil
    @State private var bgColor: Color = .restaurantListItemDefault // NOTE: if not manually set, it will be the default color
    
    var body: some View {
        HStack {
            loadedImage?
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))

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
            .foregroundColor(.defaultText) // TODO: this is font color, might need to change
            //.padding(.leading, 8)

            Spacer()
            // TODO: hide checkbox when not in selection mode
            Toggle("", isOn: $isSelected)
                .toggleStyle(CheckboxToggleStyle())
                .frame(width: 24, height: 24)
                .padding(.trailing, 12)
        }
        .background(bgColor) // changed to UIKit image average color
        .cornerRadius(12)
        .onAppear {
            loadImageAndColor(from: restaurant.imageUrl)
        }
        // long-press to show additional information
        .contextMenu {
            VStack(alignment: .leading) {
                Text(restaurant.details)
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
                self.bgColor = color.opacity(1.0)
            }
        }
    }
}
