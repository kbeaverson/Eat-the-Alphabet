//
//  ExperienceListItem.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/7/4.
//

//
//  RestaurantCardView.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/11.
//

import SwiftUI
import UIKit

// the class is to embedded with a restaurantListItem, as a Restaurant is a part of an Experience
struct ExperienceListItem: View {
    let viewModel: ExperienceViewModel = ExperienceViewModel()
    let associatedRestaurantModel: RestaurantViewModel = RestaurantViewModel()
    
    @Binding var isSelected: Bool // THIS now is part of the outer view
    var isSelectionModeOn: Bool = false // THIS now is part of the outer view
    
    var onTap: (() -> Void)? = nil // for tap handling
    
    var body: some View {
        /** TODO: a z-stack with the RestaurantListItem on the top
         a opacity=0.5 background of same color (or default to default bg)
         and the experience on the bottom with just a title "Experience of $(experience's letter)"
         */
        
        /** TODO:
         check if the user participated in the experience. If the user has not, display with a less opacity background
         */
        /**
         TODO: Is it possible to move the long-press context menu to the entire card view.
         if User Joined: add a button to the context menu red "leave", if User Not Joined: add a button to the context menu regular "join"
         */
        /**
         TODO: Make the desciption text multilines
         */
        
        ZStack {
            VStack(alignment: .leading) {
                HStack() {
                    // the experience title
                    Text("Experience of \(viewModel.experience?.letter ?? "Unknown Letter")")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    Spacer()
                    // checkbox if in selection mode
                    if (isSelectionModeOn) {
                        Toggle("", isOn: $isSelected)
                            .toggleStyle(CheckboxToggleStyle())
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 12)
                    }
                }
                // if the associated restaurant is loaded, show it
                if let restaurant = associatedRestaurantModel.restaurant {
                    RestaurantListItem(
                        restaurant: restaurant
                    )
                }
            }
        }
        .onAppear {
            // load the restaurant data
            if let experience = viewModel.experience {
                Task {
                    do {
                        try await associatedRestaurantModel.fetchRestaurant(byId: experience.restaurant_id)
                    } catch {
                        print("Failed to fetch restaurant:", error)
                    }
                }
            }
        }
        .background(.gray.opacity(isSelected ? 0.5 : 0.1))
        .cornerRadius(12)
        // long-press to show additional information
        .contextMenu {
            // options: join if not joined, leave if joined
            
        }
        .onTapGesture {
            if !isSelectionModeOn {
                onTap?()
            }
        }
    }
    
}
