//
//  RestaurantCardView.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/11.
//

import SwiftUI
import UIKit
import CoreLocation

// the class is to be embedded inside a ExperienceListItem, as a Restaurant is a part of an Experience
struct RestaurantListItem: View {
    
    var restaurant: Restaurant
    var topPadding: CGFloat = 0
    var trailingPadding: CGFloat = 0

    @State private var coord: CLLocationCoordinate2D? = nil
    @State private var userLocation: CLLocationCoordinate2D? = nil
    @State private var didSetUserLocation: Bool = false
    
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
                    Text(coord != nil && userLocation != nil ? getDistanceInMl(from: userLocation!, to: coord!) : "Distance unknown")
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
            // Load the restaurant details
            viewModel.restaurant = restaurant
            // Parse the WGS coordinates if available
            if let parsedCoord : CLLocationCoordinate2D = try? parsePointWGS(restaurant.address_wgs) {
                coord = parsedCoord
            } else {
                // get remote
                Task {
                    do {
                        let coordinate = try await viewModel.getAddressWGS(for: restaurant.id)
                        if let coordinate = coordinate {
                            await MainActor.run {
                                self.coord = coordinate
                            }
                        } else {
                            print("Failed to get coordinates for restaurant \(restaurant.id)")
                        }
                    }
                }
            }
            loadImageAndColor(from: restaurant.image_url)
            PermissionManager.shared.requestLocationPermission()
            
        }
        .onReceive(PermissionManager.shared.$currentLocation) { location in
            if !didSetUserLocation, let location = location {
                userLocation = location
                didSetUserLocation = true
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
    
    private func getDistanceInMl(from startCoordinate: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D) -> String {
        let startLocation = CLLocation(latitude: startCoordinate.latitude, longitude: startCoordinate.longitude)
        let destinationLocation = CLLocation(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)
        
        let distanceInMeters = startLocation.distance(from: destinationLocation)
        let distanceInMiles = distanceInMeters * 0.000621371 // Convert meters to miles
        return String(format: "%.2f mi", distanceInMiles)
    }
    
    private func parsePointWGS(_ address_wgs: String?) throws -> CLLocationCoordinate2D {
        guard let address_wgs = address_wgs, !address_wgs.isEmpty else {
            throw NSError(domain: "ParsePointWGS", code: 400, userInfo: [NSLocalizedDescriptionKey: "Address WGS is nil or empty"])
        }
        let coordinates = address_wgs
            .replacingOccurrences(of: "POINT(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .split(separator: " ")
            .compactMap { Double($0) }
        
        guard coordinates.count == 2 else {
            throw NSError(domain: "ParsePointWGS", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid POINT format: \(address_wgs)"])
        }
        let latitude = coordinates[1]
        let longitude = coordinates[0]
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
