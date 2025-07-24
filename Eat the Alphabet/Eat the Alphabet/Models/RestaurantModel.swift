//
//  restaurant.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/4/25.
//
import CoreLocation

// NOTE: changed to struct, original Restaurant model, 不含业务逻辑、不含 UI 信息、不处理数据库访问。
struct Restaurant: Codable, Identifiable {
    let id : String
    var name : String
    let created_at : Date
    var cuisine : String
    var avg_per_cost : Int?
    let map_imported_id: String
    let map_imported_rating : Int?
    var rating : Int?
    var address_wgs : String? // FIXME: Temporarily optional until decoding is handled properly
    var address_text : String?
    let details : String?
    let image_url : String?
    
    // Experience in the upper stream of the restaurant !!!
    // NOTE: do not include Experience, else there will be a cyclic dependency.
    
    // TEST: constructor from just data
    init(id: String,
         name: String,
         created_at: Date,
         cuisine: String,
         avg_per_cost: Int? = nil,
         map_imported_id: String,
         map_imported_rating: Int? = nil,
         rating: Int? = nil,
         address_wgs: String?, // Should be Geopoint? Made String to fix build errors
         address_text: String? = nil,
         details: String? = nil,
         image_url: String? = nil) {
        self.id = id
        self.name = name
        self.created_at = created_at
        self.cuisine = cuisine
        self.avg_per_cost = avg_per_cost
        self.map_imported_id = map_imported_id
        self.map_imported_rating = map_imported_rating
        self.rating = rating
        self.address_wgs = address_wgs
        self.address_text = address_text
        self.details = details
        self.image_url = image_url
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case created_at = "created_at"
        case cuisine = "cuisine"
        case avg_per_cost = "avg_per_cost"
        case map_imported_id = "map_imported_id"
        case map_imported_rating = "map_imported_rating"
        case rating = "rating"
        case address_wgs = "address_wgs"
        case address_text = "address_text"
        case details = "details"
        case image_url = "image_url"
    }
         
}
