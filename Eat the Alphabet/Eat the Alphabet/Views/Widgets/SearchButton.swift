//
//  SearchButton.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 7/20/25.
//
import SwiftUI
import MapKit

struct SearchButton: View {
    @Binding var searchResults: [MKMapItem]
    @State var query: String = ""
    var visibleRegion: MKCoordinateRegion?
    
    var body: some View {
        HStack {
            TextField("Search for a restaurant", text: $query)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .onSubmit {
                    search(for: "\(query) restaurant")
                }
        }
    }
    
    func search(for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = visibleRegion ?? MKCoordinateRegion(
            center: .columbus,
            span: MKCoordinateSpan(latitudeDelta: 0.125, longitudeDelta: 0.125)
        )
        Task {
            print("Searching for restaurants")
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
            print("Found \(searchResults.count) restaurants")
        }
    }
}
