//
//  FirebaseTestHelper.swift
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

class FirebaseTestHelper {
    static func createTestUser(email: String, password: String, displayName: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Failed to create user: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let user = authResult?.user else {
                completion(false)
                return
            }

            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            changeRequest.commitChanges { error in
                if let error = error {
                    print("Failed to update displayName: \(error.localizedDescription)")
                    completion(false)
                    return
                } else {
                    print("User created successfully with displayName: \(displayName)")
                    
                    
                    Auth.auth().currentUser?.reload { reloadError in
                        if let reloadError = reloadError {
                            print("Failed to reload user: \(reloadError.localizedDescription)")
                            completion(false)
                            return
                        }
                        
                       
                        guard let userID = Auth.auth().currentUser?.uid else {
                            completion(false)
                            return
                        }

                        let db = Firestore.firestore()
                        let userDoc = db.collection("users").document(userID)
                        userDoc.setData([
                            "userName": displayName,
                            "email": email
                        ], merge: true) { error in
                            if let error = error {
                                print("Failed to save user profile to Firestore: \(error.localizedDescription)")
                                completion(false)
                            } else {
                                print("User profile saved to Firestore successfully.")
                                completion(true)
                            }
                        }
                    }
                }
            }
        }
    }


    static func simulateUserLogin(for email: String, password: String, completion: @escaping (Bool) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            print("User already logged in: \(currentUser.uid), displayName: \(currentUser.displayName ?? "Unknown")")
            completion(true)
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Login failed with error: \(error.localizedDescription)")
                completion(false)
                return
            }

            if let user = authResult?.user {
                print("Successfully logged in with userID: \(user.uid), displayName: \(user.displayName ?? "Unknown")")
                completion(true)
            } else {
                print("Login failed: Unknown error")
                completion(false)
            }
        }
    }


    static func simulateUserSignUp(for email: String, password: String, displayName: String, completion: @escaping (Bool) -> Void) {
        createTestUser(email: email, password: password, displayName: displayName) { success in
            if success {
                simulateUserLogin(for: email, password: password, completion: completion)
            } else {
                completion(false)
            }
        }
    }
}

