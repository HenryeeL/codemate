//
//  CommentManager.swift
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class CommentManager {
    // MARK: - Properties
    private let db = Firestore.firestore()
    private let commentsCollection = "comments"
    private var commentsListener: ListenerRegistration?

    // MARK: - Load Comments
    func loadComments(completion: @escaping (Result<[Comment], Error>) -> Void) {
        db.collection(commentsCollection)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }

                let comments = documents.compactMap { doc -> Comment? in
                    var data = doc.data()
                    data["commentID"] = doc.documentID
                    return Comment(from: data) //
                }
                completion(.success(comments))
            }
    }

    // MARK: - Add Comment
    
    func addComment(_ comment: Comment, completion: @escaping (Result<Comment, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "CommentManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])))
            return
        }

        var commentData = comment.toDictionary()
        commentData["commentID"] = nil

        
        let documentRef = db.collection(commentsCollection).document()
        commentData["commentID"] = documentRef.documentID 

        
        documentRef.setData(commentData) { error in
            if let error = error {
                print("Error adding comment: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                
                var updatedComment = comment
                updatedComment.commentID = documentRef.documentID
                print("Comment added with ID: \(documentRef.documentID)")
                completion(.success(updatedComment))
            }
        }
    }

    // MARK: - Real-Time Listener
    
    func startListening(completion: @escaping (Result<[Comment], Error>) -> Void) {
        commentsListener = db.collection(commentsCollection)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }

                let comments = documents.compactMap { doc -> Comment? in
                    var data = doc.data()
                    data["commentID"] = doc.documentID
                    return Comment(from: data)
                }
                completion(.success(comments))
            }
    }

    // MARK: - Stop Listening
    
    func stopListening() {
        commentsListener?.remove()
        commentsListener = nil
    }
    // MARK: - Delete Comment
    func deleteComment(_ comment: Comment, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let commentID = comment.commentID else {
            print("Invalid comment ID detected.")
            completion(.failure(NSError(domain: "CommentManager", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid comment ID."])))
            return
        }

        print("Deleting comment with ID: \(commentID)")

        db.collection(commentsCollection).document(commentID).delete { error in
            if let error = error {
                print("Error deleting comment: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Comment successfully deleted.")
                completion(.success(()))
            }
        }
    }
}
