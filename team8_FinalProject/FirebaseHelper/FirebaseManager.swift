//
//  FirebaseManager.swift
//

import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class FirebaseManager {
    
    static let shared = FirebaseManager()

    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    private init() {}

    
    func getCurrentUserID() -> String? {
        if let currentUser = Auth.auth().currentUser {
            print("Current User ID: \(currentUser.uid)") // 打印用户 ID
            return currentUser.uid
        } else {
            print("No user is currently logged in.")
            return nil
        }
    }

    
    func fetchUserProfile(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let userID = getCurrentUserID() else {
            completion(.failure(NSError(domain: "FirebaseManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }

        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = document?.data() {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "FirebaseManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "User profile not found"])))
            }
        }
    }

    
    func updateUserProfile(username: String, profileImageURL: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userID = getCurrentUserID() else {
            completion(.failure(NSError(domain: "FirebaseManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }

        
        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = document?.data(), let currentEmail = data["email"] as? String else {
                completion(.failure(NSError(domain: "FirebaseManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "User profile not found"])))
                return
            }

            
            var updatedData: [String: Any] = [
                "userName": username,
                "email": currentEmail
            ]
            
            if let profileImageURL = profileImageURL {
                updatedData["profileImageURL"] = profileImageURL
            }

            
            self.db.collection("users").document(userID).setData(updatedData, merge: true) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    /*
    func updateUserProfile(username: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userID = getCurrentUserID() else {
            completion(.failure(NSError(domain: "FirebaseManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }

        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = document?.data(), let currentEmail = data["email"] as? String else {
                completion(.failure(NSError(domain: "FirebaseManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "User profile not found"])))
                return
            }

            // Only update the username
            let updatedData: [String: Any] = [
                "userName": username,
                "email": currentEmail
            ]

            self.db.collection("users").document(userID).setData(updatedData, merge: true) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
     */

    
    func uploadProfileImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let userID = getCurrentUserID() else {
            completion(.failure(NSError(domain: "FirebaseManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }

        let storageRef = storage.reference().child("profile_images/\(userID).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "FirebaseManager", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])))
            return
        }

        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                }
            }
        }
    }
}
