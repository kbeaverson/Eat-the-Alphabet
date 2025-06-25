//
//  ExperienceRepository.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//


import Foundation
import SwiftUICore
import Supabase

class ExperienceRepository {
    let client : SupabaseClient
    
    init(client : SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
    }
    
    func createExperience(experience : Experience) async throws {
        try await client
            .from("Experience")
            .insert(experience)
            .execute()
    }
    
    func fetchAllExperiences(for userID: String) async throws -> [Experience] {
        let experiences: [ExperienceParticipant] = try await client
            .from("Experience_Participant")
            .select()
            .eq("user_id", value: userID)
            .execute()
            .value
        
        let experienceIDs = experiences.map { $0.experienceID }
        
        if (experienceIDs.isEmpty) {
            return []
    static let shared = ExperienceRepository()
    // Read - get all
    func loadAllExperiences(completion: @escaping (Result<[Experience], Error>) -> Void) {
        Task {
            do {
                let response: [Experience] = try await SupabaseManager.shared.client
                    .from("experiences")
                    .select()
                    .execute()
                    .value
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        
    }
    
    // Read - get by id
    func loadExperienceById(id: String, completion: @escaping (Result<Experience, Error>) -> Void) {
        Task {
            do {
                let response: Experience = try await SupabaseManager.shared.client
                    .from("experiences")
                    .select()
                    .eq("id", value: id)
                    .execute()
                    .value
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Read - get by challenge_id
    func loadExperiencesByChallengeId(challengeId: String, completion: @escaping (Result<[Experience], Error>) -> Void) {
        Task {
            do {
                let response: [Experience] = try await SupabaseManager.shared.client
                    .from("experiences")
                    .select()
                    .eq("challenge_id", value: challengeId)
                    .execute()
                    .value
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Create - add new experience
    
    // Delete - remove experience by id
    func removeExperienceById(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await SupabaseManager.shared.client
                    .from("experiences")
                    .delete()
                    .eq("id", value: id)
                    .execute()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Update - update experience by id, with an Experience object
    func updateExperience(_ experience: Experience, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await SupabaseManager.shared.client
                    .from("experiences")
                    .update(experience)
                    .eq("id", value: experience.id)
                    .execute()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
        
    // Update - update experience with photo
    // upload photo to bucket 'experienceimages', if succeed, write the retsponse URL to the image_url field of the Experience object, update it to the database
    // Adds a SwiftUI Image to Supabase storage and updates Experience.photo_url
        func addPhoto(photo: Image, experience_id: String, completion: @escaping (Result<Void, Error>) -> Void) {
            // Convert SwiftUI Image to UIImage (must be handled via ImageRenderer or similar)
            guard let uiImage = photo.asUIImage(), // see extension below
                  let imageData = uiImage.pngData() else {
                completion(.failure(PhotoUploadError.invalidImage))
                return
            }

            let fileName = UUID().uuidString + ".png"
            let bucket = SupabaseStorageHelper.Bucket.experienceImages

            // Step 1: Upload image to bucket
            SupabaseStorageHelper.shared.uploadImage(image: uiImage, to: bucket, fileName: fileName) { result in
                switch result {
                case .success(let imagePath):
                    do {
                    let publicUrl = try SupabaseManager.shared.client.storage
                        .from(bucket.rawValue)
                        .getPublicURL(path: imagePath)
                    // Step 2: Retrieve existing Experience object
                        Task {
                            do {
                                var experience: Experience = try await SupabaseManager.shared.client
                                    .from("experiences")
                                    .select()
                                    .eq("id", value: experience_id)
                                    .single()
                                    .execute()
                                    .value
                                
                                // Step 3: Append new photo URL to existing array
                                var updatedPhotos = experience.photo_url ?? []
                                updatedPhotos.append(publicUrl.absoluteString)
                                
                                // Step 4: Update database
                                try await SupabaseManager.shared.client
                                    .from("experiences")
                                    .update(["photo_url": updatedPhotos])
                                    .eq("id", value: experience_id)
                                    .execute()
                                
                                completion(.success(()))
                            } catch {
                                completion(.failure(error))
                            }
                        }
                    } catch {
                        completion(.failure(error))
                    }

                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
    // remove photo from the bucket, if succeed, (remove the photo from the photos array, in the Model and ViewModel) and update the Experience object, update to the database
    func removePhoto(at index: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        // self.photos.remove(at: index)
        
    }
    
    // add a Review to the Experience, if succeed (unlikely this step would fail), append the Review to the reviews array in the Experience object, update it to the database
    func addReview(_ review: Review, completion: @escaping (Result<Void, Error>) -> Void) {
        // self.reviews.append(review)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success(()))
        }
        
        return try await client
            .from("Experience")
            .select()
            .in("experience_id", values: experienceIDs)
            .execute()
            .value
    }
    
    func updateExperience(experience : Experience) async throws {
        try await client
            .from("Experience")
            .upsert(experience)
            .execute()
    }
    
    func deleteExperience(experience : Experience) async throws {
        try await client
            .from("Experience")
            .delete()
            .eq("id", value: experience.id)
            .execute()
    }
    
    func fetchReviews(for experienceID : String) async throws -> [Review] {
        return try await client
            .from("Review")
            .select()
            .eq("experience_id", value: experienceID)
            .execute()
            .value
    }
    
    func fetchParticipants(for experienceID : String) async throws -> [Review] {
        let participants: [ExperienceParticipant] = try await client
            .from("Experience_Participant")
            .select()
            .eq("experience_id", value: experienceID)
            .execute()
            .value
        
        let userIDs = participants.map { $0.userID }
        
        if (userIDs.isEmpty) {
            return []
        }
        
        return try await client
            .from("User")
            .select()
            .in("id", values: userIDs)
            .execute()
            .value
    }
}

enum PhotoUploadError: Error {
    case invalidImage
}
