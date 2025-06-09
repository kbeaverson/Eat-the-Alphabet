//
//  challenge.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 6/4/25.
//
import CoreLocation

class Challenge {
    let id : Int
    var address : CLLocationCoordinate2D
    var radius : Float
    let createDate : Date
    var restaurants : [Restaurant]
    var participants : [User]
    var experiences : [Experience]
    var remainingLetters : [Character]
    
    init(id: Int, address: CLLocationCoordinate2D, radius: Float, createDate: Date, restaurants: [Restaurant], participants: [User], experiences: [Experience], remainingLetters: [Character]) {
        self.id = id
        self.address = address
        self.radius = radius
        self.createDate = createDate
        self.restaurants = restaurants
        self.participants = participants
        self.experiences = experiences
        self.remainingLetters = remainingLetters
    }
    
    func addUser(_ user: User) {
        participants.append(user)
    }
    
    func setAddress(_ address: CLLocationCoordinate2D) {
        self.address = address
    }
    
    func setRadius(_ radius: Float) {
        self.radius = radius
    }
    
    func addExperience(_ experience: Experience) {
        experiences.append(experience)
    }
    
    func removeLetter(_ letter: Character) {
        if let index = remainingLetters.firstIndex(of: letter) {
            remainingLetters.remove(at: index)
        }
    }
}
