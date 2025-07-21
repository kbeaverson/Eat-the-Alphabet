//
//  ExperienceListItem.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/7/4.


import SwiftUI
import UIKit

// the class is to embedded with a restaurantListItem, as a Restaurant is a part of an Experience
struct ExperienceListItem: View {
    // PASSED-IN experience
    var experience: Experience
    
    @StateObject private var viewModel: ExperienceViewModel = ExperienceViewModel()
    // @StateObject private var associatedRestaurantModel: RestaurantViewModel = RestaurantViewModel()
    
    @Binding var isSelected: Bool // THIS now is part of the outer view
    var isSelectionModeOn: Bool = false // THIS now is part of the outer view
    var onTap: (() -> Void)? = nil // for tap handling
    
    var body: some View {
        NavigationLink( destination: ExperienceDetailsView(
            experience: viewModel.experience ?? experience,
        )){
            VStack(alignment: .leading) {
                HStack() {
                    // the experience title
                    Text("Experience of \(viewModel.experience?.letter ?? "Unknown Letter")")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(.primary)
                        .padding(3)
                        .background(.clear)
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
                if let restaurant = viewModel.experience?.restaurant {
                    RestaurantListItem(
                        restaurant: restaurant
                    )
                }
            }
            .padding(8)
            .onAppear {
                viewModel.experience = experience
                if let restaurant = experience.restaurant {
                    viewModel.experience?.restaurant = restaurant
                    print("直接使用传入的 restaurant: \(restaurant)")
                } else {
                    print("需要异步加载 restaurant")
                    Task {
                        await viewModel.loadAssociatedRestaurant()
                    }
                }
            }
            .background(.white.opacity(isSelected ? 0.5 : 0.1))
            .cornerRadius(12)
            // long-press to show additional information
            .contextMenu {
                // options: join if not joined, leave if joined
                
            }
//            .onTapGesture {
//                if !isSelectionModeOn {
//                    onTap?()
//                }
//            }
        }
    }
}
