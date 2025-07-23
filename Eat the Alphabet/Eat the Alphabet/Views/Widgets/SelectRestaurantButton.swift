//
//  SelectRestaurantButton.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 7/21/25.
//
import SwiftUI
import MapKit

struct SelectRestaurantButton: View {
    @Environment(\.dismiss) private var dismiss
    
    var selectedRestaurant: MKMapItem
    @Binding var restaurant: Restaurant?
    
    // var dismissCallback: (() -> Void)? = nil
    
    var restaurantRepository: RestaurantRepository = RestaurantRepository()
    
    var body: some View {
        HStack {
            Button(action: selectRestaurant) {
                Text("Select Restaurant for Experience")
            }
            .buttonStyle(.bordered)
        }
    }
    
    func selectRestaurant() {
        Task {
            let presentRest = try? await restaurantRepository.getRestaurant(byMapID: selectedRestaurant.identifier?.rawValue ?? "No identifier provided")
            if presentRest != nil {
                print("Restaurant found in database.")
                restaurant = presentRest!
            } else {
                print("Restaurant not found in database. Creating.")
                let id = UUID()
                let address_wgs: String = "POINT(\(selectedRestaurant.placemark.coordinate.latitude) \(selectedRestaurant.placemark.coordinate.longitude))"
                let newRest = Restaurant(
                    id: id.uuidString,
                    name: selectedRestaurant.name ?? "No name provided.",
                    created_at: Date.now,
                    cuisine: "Placeholder",
                    map_imported_id: selectedRestaurant.identifier?.rawValue ?? "None found",
                    address_wgs: address_wgs
                    )
                try? await restaurantRepository.createRestaurant(restaurant: newRest)
                restaurant = newRest
                
                // Navigate back to the previous view
                dismiss()
            }
        }
    }
}
